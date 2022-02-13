import * as React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
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

export default function ListObjects({ title, columns, data, order, filter, onClick, openFilter, rowHeight = 77 }) {
  const [orderDir, setOrderDir] = React.useState('asc');
  const [orderBy, setOrderBy] = React.useState('id');
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(5);

  const handleClick = (e, id) => {
    e.preventDefault();
    onClick(id);
  };

  const handleRequestSort = (e, property) => {
    e.preventDefault();
    setOrderDir(orderBy === property && orderDir === 'asc' ? 'desc' : 'asc');
    setOrderBy(property);
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

  let rows = Object.values(data);
  if (filter) {
    rows = rows.filter(filter);
  }
  if (order) {
    rows = rows.sort(orderDir === 'desc'
      ? (a, b) => order(a, b, orderBy)
      : (a, b) => -order(a, b, orderBy))
  }

  // Avoid a layout jump when reaching the last page with empty rows.
  const emptyRows =
    page > 0 ? Math.max(0, (1 + page) * rowsPerPage - rows.length) : 0;

  const colSpan = columns.length;

  return (
    <Paper sx={{ width: '100%', mb: 2 }}>

      <FilterableTableToolbar
        title={title}
        openFilter={openFilter}
      />

      <TableContainer>
        <Table
          sx={{ minWidth: 750 }}
          aria-labelledby="tableTitle"
          size="medium"
        >

          <SortableTableHead
            columns={columns}
            orderDir={orderDir}
            orderBy={orderBy}
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
                  {columns.map(({ name, align, render }, index) => (
                    <TableCell
                      key={`table-column-${row.id}-${name}`}
                      align={align}
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

      <TablePagination
        rowsPerPageOptions={[5, 10, 25]}
        component="div"
        count={rows.length}
        rowsPerPage={rowsPerPage}
        page={page}
        onPageChange={handleChangePage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />

    </Paper>
  );
};

ListObjects.propTypes = {
  title: PropTypes.string.isRequired,
  columns: PropTypes.arrayOf(PropTypes.object).isRequired,
  data: PropTypes.objectOf(PropTypes.object).isRequired,
  order: PropTypes.func,
  filter: PropTypes.func,
  onClick: PropTypes.func,
  openFilter: PropTypes.func,
  rowHeight: PropTypes.number,
};


function SortableTableHead({ columns, orderBy, orderDir, onRequestSort }) {
  const createSortHandler = (property) => (event) => onRequestSort(event, property);

  return (
    <TableHead>
      <TableRow>
        {columns.map(({ name, align, label }) => (
          <TableCell
            key={`sortable-table-head-${name}`}
            align={align}
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
    align: PropTypes.oneOf(['left', 'right']),
    render: PropTypes.func.isRequired,
  })).isRequired,
  onRequestSort: PropTypes.func.isRequired,
  orderDir: PropTypes.oneOf(['asc', 'desc']).isRequired,
  orderBy: PropTypes.string.isRequired,
};

const FilterableTableToolbar = ({ title, openFilter }) => {
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

      {openFilter && (
        <Tooltip title="Filter list">
          <IconButton>
            <FilterListIcon />
          </IconButton>
        </Tooltip>
      )}
    </Toolbar>
  );
};

FilterableTableToolbar.propTypes = {
  title: PropTypes.string.isRequired,
  openFilter: PropTypes.func,
};
