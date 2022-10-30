import * as React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import Collapse from '@mui/material/Collapse';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TablePagination from '@mui/material/TablePagination';
import TableRow from '@mui/material/TableRow';
import TableSortLabel from '@mui/material/TableSortLabel';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import FilterListIcon from '@mui/icons-material/FilterList';
import { visuallyHidden } from '@mui/utils';

export default function ListObjects({ title, columns, data, order, searchForm: SearchForm, defaultFilters, filter, onClick, rowHeight, rowsPerPageOptions }) {
  const [orderDir, setOrderDir] = React.useState('asc');
  const [orderBy, setOrderBy] = React.useState({ column: 'id', fields: ['id'] });
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(rowsPerPageOptions[0]);
  const [searchExpanded, setSearchExpanded] = React.useState(false);
  const [filters, setFilters] = React.useState({});

  const handleToggleSearch = () => {
    setSearchExpanded(!searchExpanded);
  };

  const handleClick = (e, id) => {
    e.preventDefault();
    if (onClick) onClick(id);
  };

  const handleCloseFilter = () => {
    setSearchExpanded(false)
  }

  const handleRequestSort = (e, property) => {
    e.preventDefault();
    setOrderDir(orderBy.column === property && orderDir === 'asc' ? 'desc' : 'asc');
    setPage(0);

    const sortFields = columns.reduce((sortFields, column) => {
      if (column.name === property && 'sortFields' in column) {
        return [...column.sortFields, 'id'];
      }

      return sortFields;
    }, [property, 'id']);

    setOrderBy({ column: property, fields: sortFields });
  };

  const handleChangePage = (e, newPage) => {
    e.preventDefault();
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (e) => {
    e.preventDefault();
    setRowsPerPage(parseInt(e.target.value, 10));
    setPage(0);
  };

  if (!data) return null;

  const rows = (Array.isArray(data) ? data : Object.values(data))
    .filter(filter ? (row) => filter(filters, row) : () => true)
    .sort(order ? (
      orderDir === 'desc'
        ? (a, b) => order(a, b, orderBy.fields)
        : (a, b) => -order(a, b, orderBy.fields)
    ) : (a, b) => 0);

  // Avoid a layout jump when reaching the last page with empty rows.
  const emptyRows =
    page > 0 ? Math.max(0, (1 + page) * rowsPerPage - rows.length) : 0;

  const colSpan = columns.length;

  const canFilter = filter && SearchForm;

  return (
    <Paper sx={{ width: '100%', mb: 2 }}>

      <FilterableTableToolbar
        title={title}
        toggleSearch={canFilter ? handleToggleSearch : null}
      />

      {canFilter && (
        <Collapse in={searchExpanded} timeout="auto" unmountOnExit>
          <SearchForm
            onFilter={setFilters}
            onClose={handleCloseFilter}
          />
        </Collapse>
      )}

      <TableContainer>
        <Table
          sx={{ minWidth: 750 }}
          aria-labelledby="tableTitle"
          size="medium"
        >

          <SortableTableHead
            columns={columns}
            orderDir={orderDir}
            orderBy={orderBy.column}
            onRequestSort={handleRequestSort}
          />

          <TableBody>
            {rows.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((row) => (
                <TableRow
                  hover
                  onClick={(event) => handleClick(event, row.id)}
                  tabIndex={-1}
                  key={`table-row-${row.id}`}
                  style={{
                    height: `${rowHeight}px`,
                  }}
                >
                  {columns.map(({ name, align, render, sx }, index) => (
                    <TableCell
                      key={`table-column-${row.id}-${name}`}
                      align={align}
                      sx={sx}
                      component={index === 0 ? "th" : "td"}
                      scope="row"
                    >
                      {render(row)}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            }

            {emptyRows > 0 && (
              <TableRow
                sx={{
                  height: `${rowHeight * emptyRows}px`,
                }}
              >
                <TableCell colSpan={colSpan} />
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>

      {rows.length > rowsPerPage && <TablePagination
        rowsPerPageOptions={[5, 10, 25]}
        component="div"
        count={rows.length}
        rowsPerPage={rowsPerPage}
        page={page}
        onPageChange={handleChangePage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />}

    </Paper>
  );
};

ListObjects.defaultProps = {
  rowsPerPageOptions: [5, 10, 25],
  rowHeight: 85,
}

ListObjects.propTypes = {
  title: PropTypes.string.isRequired,
  columns: PropTypes.arrayOf(PropTypes.object).isRequired,
  data: PropTypes.oneOfType([
    PropTypes.objectOf(PropTypes.object),
    PropTypes.arrayOf(PropTypes.object),
  ]).isRequired,
  order: PropTypes.func,
  defaultFilters: PropTypes.object,
  searchForm: PropTypes.elementType,
  filter: PropTypes.func,
  onClick: PropTypes.func,
  toggleSearch: PropTypes.func,
  rowHeight: PropTypes.number,
  rowsPerPageOptions: PropTypes.arrayOf(PropTypes.number),
};


function SortableTableHead({ columns, orderBy, orderDir, onRequestSort }) {
  const createSortHandler = (property) => (event) => onRequestSort(event, property);

  return (
    <TableHead>
      <TableRow>
        {columns.map(({ name, align, label, sx }) => (
          <TableCell
            key={`sortable-table-head-${name}`}
            align={align}
            sx={sx}
            sortDirection={orderBy === name ? orderDir : false}
          >
            <TableSortLabel
              active={orderBy === name}
              direction={orderBy === name ? orderDir : 'asc'}
              onClick={createSortHandler(name)}
            >
              {label}
              {orderBy === name ? (
                <Box component="span" sx={visuallyHidden}>
                  {orderDir === 'desc' ? 'sorted descending' : 'sorted ascending'}
                </Box>
              ) : null}
            </TableSortLabel>
          </TableCell>
        ))}
      </TableRow>
    </TableHead>
  );
}

SortableTableHead.propTypes = {
  columns: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.string.isRequired,
    label: PropTypes.string.isRequired,
    align: PropTypes.oneOf(['left', 'center', 'right']),
    render: PropTypes.func.isRequired,
    sx: PropTypes.object,
  })).isRequired,
  onRequestSort: PropTypes.func.isRequired,
  orderDir: PropTypes.oneOf(['asc', 'desc']).isRequired,
  orderBy: PropTypes.string.isRequired,
};

const FilterableTableToolbar = ({ title, toggleSearch }) => {
  return (
    <Toolbar
      sx={{
        pl: { sm: 2 },
        pr: { xs: 1, sm: 1 },
      }}
    >
      <Typography
        sx={{ flex: '1 1 100%' }}
        variant="h6"
        id="tableTitle"
        component="div"
      >
        {title}
      </Typography>

      {toggleSearch && (
        <Tooltip title="Filter list">
          <IconButton onClick={toggleSearch}>
            <FilterListIcon />
          </IconButton>
        </Tooltip>
      )}
    </Toolbar>
  );
};

FilterableTableToolbar.propTypes = {
  title: PropTypes.string.isRequired,
  toggleSearch: PropTypes.func,
};
