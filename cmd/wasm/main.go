//go:build js && wasm

package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"syscall/js"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

var (
	jsErr     js.Value = js.Global().Get("Error")
	jsPromise js.Value = js.Global().Get("Promise")
)

func main() {
	log.Printf("%s %s (%s-%s @ %s)\n",
		build.Name, build.Version, build.Branch, build.Commit, build.Timestamp)

	js.Global().Set("NewDnDMachine", NewDnDMachine())

	js.Global().Get("onDnDMachineStarted").Invoke()
	<-make(chan bool)
}

func internalProvider(uuid character.UUID) (*options.Object, error) {
	// Make the HTTP request
	uri := fmt.Sprintf("/api/character-option/uuid/%v", uuid)
	res, err := http.DefaultClient.Get(uri)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	wrapped := struct {
		Result options.Object `json:"result"`
	}{}

	err = json.NewDecoder(res.Body).Decode(&wrapped)
	if err != nil {
		return nil, err
	}

	return &wrapped.Result, nil
}

func externalProvider(provider js.Value) func(uuid character.UUID) (*options.Object, error) {
	return func(uuid character.UUID) (*options.Object, error) {
		log.Printf("Option: fetching %q\n", uuid)

		args, err := await(provider.Invoke(string(uuid)))
		if err != nil {
			log.Printf("Option: provider returned error: %v\n", err)
			return nil, err
		}

		if len(args) != 1 {
			log.Printf("Option: provider returned nothing\n")
			return nil, fmt.Errorf("missing return value")
		}

		o := options.Object{}
		err = json.Unmarshal([]byte(args[0].String()), &o)
		log.Printf("Option: %v := json.Unmarshal(%v, %v)\n", err, args[0].String(), o)
		if err != nil {
			log.Printf("Option: failed to parse: %v\n", err)
			return nil, fmt.Errorf("Option: failed to read option argument: %w", err)
		}

		return &o, nil
	}
}

// await returns the result js.Value or Go error of an async javascript function
func await(fn js.Value) ([]js.Value, error) {
	if fn.Type() != js.TypeObject || fn.Get("then").Type() != js.TypeFunction {
		return []js.Value{}, fmt.Errorf("not an async function")
	}

	success := make(chan []js.Value)
	failure := make(chan error)

	resolve := js.FuncOf(func(this js.Value, args []js.Value) any {
		success <- args
		return nil
	})
	defer resolve.Release()

	reject := js.FuncOf(func(this js.Value, args []js.Value) any {
		// https://github.com/golang/go/blob/master/src/net/http/roundtrip_js.go#L273
		errMsg := args[0].String()

		failure <- fmt.Errorf("promise rejected: %v", errMsg)

		return nil
	})
	defer reject.Release()

	catch := js.FuncOf(func(this js.Value, args []js.Value) any {
		// https://github.com/golang/go/blob/master/src/net/http/roundtrip_js.go#L273
		jsErr := args[0]

		errMsg := jsErr.String()

		cause := jsErr.Get("cause")
		switch {
		case cause.IsUndefined():
			return nil
		case !cause.Get("toString").IsUndefined():
			errMsg += ": " + cause.Call("toString").String()
		case cause.Type() == js.TypeString:
			errMsg += ": " + cause.String()
		}

		failure <- fmt.Errorf("error caught: %v", errMsg)

		return nil
	})
	defer catch.Release()

	fn.Call("then", resolve, reject).Call("catch", catch)

	select {
	case val := <-success:
		return val, nil
	case err := <-failure:
		return []js.Value{}, err
	}
}

// NewDnDMachine returns an object with a function to recompute a
// character. If a function is passed it should be able to return character
// option objects based on a uuid.
func NewDnDMachine() js.Func {
	return js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		return map[string]interface{}{
			"CharacterCompute": CharacterCompute(),
			"OptionProvider":   args[0],
		}
	})
}

// CharacterCompute returns a Promise that resolves after having recomputed the
// character choices
func CharacterCompute() js.Func {
	return js.FuncOf(func(this js.Value, args []js.Value) interface{} {

		provider := internalProvider
		if p := this.Get("OptionProvider"); !p.IsUndefined() && p.Type() == js.TypeFunction {
			provider = externalProvider(p)
			log.Printf("using external provider\n")
		} else {
			log.Printf("using internal provider\n")
		}

		handler := js.FuncOf(func(this js.Value, promise []js.Value) interface{} {

			defer func() {
				if err := recover(); err != nil {
					// reject promise
					promise[1].Invoke(err)
				}
			}()

			go func(resolve, reject js.Value, args []js.Value) {
				log.Printf("Character: args: %v, %v, %v\n", resolve, reject, args)

				if len(args) < 1 {
					jsErr := jsErr.New("missing character argument")
					reject.Invoke(jsErr)
					return
				}

				c := character.Object{}
				err := json.Unmarshal([]byte(args[0].String()), &c)
				log.Printf("Character: %v := json.Unmarshal(%v, %v)\n", err, args[0].String(), c)
				if err != nil {
					jsErr := jsErr.New(err.Error())
					reject.Invoke(jsErr)
					return
				}

				u, err := options.Recompute(&c, provider)
				if err != nil {
					jsErr := jsErr.New(err.Error())
					reject.Invoke(jsErr)
					return
				}

				str, err := json.Marshal(u)
				log.Printf("Character: %v, %v := json.Unmarshal(%v)\n", str, err, u)
				if err != nil {
					jsErr := jsErr.New(err.Error())
					reject.Invoke(jsErr)
					return
				}

				resolve.Invoke(string(str))
			}(promise[0], promise[1], args)

			// The handler of a Promise doesn't return any value
			return nil
		})

		// Create and return the Promise object
		return jsPromise.New(handler)
	})
}
