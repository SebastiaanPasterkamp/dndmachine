export default function stringToInitials(string) {
    const strLen = string.length;
    if (strLen <= 0) {
        return string;
    }

    const parts = string.split(' ');
    const items = parts.length;
    if (items > 1) {
        return `${parts[0][0]}${parts[items - 1][0]}`;
    }

    return `${string[0]}${string[strLen - 1]}`;
}
