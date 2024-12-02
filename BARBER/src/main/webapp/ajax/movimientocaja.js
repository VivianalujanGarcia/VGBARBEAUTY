$(document).ready(function () {
    cargarApertura();
    cargarmonto();
    cargarfecha();
    mostrardetalles();
    cargarmfinal();

    // Maneja la búsqueda en tiempo real
    $('#search').on('input', function () {
        currentPage = 1;
        filterTable();
    });
});

const rowsPerPage = 5;  // Número de filas a mostrar por página
let currentPage = 1;
let allRows = [];

// Función para renderizar las filas en la tabla
function renderTable(rows) {
    const tbody = $("#resultados");
    tbody.empty();
    rows.forEach(row => {
        tbody.append(row);
    });
}

// Función para manejar la paginación
function paginate(rows) {
    const totalRows = rows.length;
    const totalPages = Math.ceil(totalRows / rowsPerPage);
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const paginatedRows = Array.from(rows).slice(start, end);

    renderTable(paginatedRows);
    renderPagination(totalPages);
}

// Función para renderizar los botones de paginación
function renderPagination(totalPages) {
    const pagination = $("#pagination");
    pagination.empty();

    for (let i = 1; i <= totalPages; i++) {
        const pageItem = $('<a href="#" class="page-link"></a>').text(i);
        if (i === currentPage) {
            pageItem.addClass('active');
        }
        pageItem.on('click', function (e) {
            e.preventDefault();
            currentPage = i;
            filterTable();
        });
        pagination.append(pageItem);
    }
}

// Función para filtrar la tabla según el término de búsqueda
function filterTable() {
    const searchTerm = $('#search').val().toLowerCase();
    const filteredRows = Array.from(allRows).filter(row => {
        const cells = row.getElementsByTagName('td');
        for (let i = 0; i < cells.length; i++) {
            const cellText = cells[i].textContent.toLowerCase();
            if (cellText.includes(searchTerm)) {
                return true;
            }
        }
        return false;
    });
    console.log("Filas filtradas:", filteredRows.length); // Log de depuración
    paginate(filteredRows);
}

// Funciones AJAX para cargar datos desde el servidor
function cargarApertura() {
    $.ajax({
        url: 'jsp/buscarapertura.jsp',
        type: 'post',
        success: function (response) {
            $("#idaperturas").val(response.trim());
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar apertura: " + status + " - " + error);
        }
    });
}

function cargarfecha() {
    $.ajax({
        url: 'jsp/buscarfecha.jsp',
        type: 'post',
        success: function (response) {
            $("#fecharegistro").val(response.trim());
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar fecha: " + status + " - " + error);
        }
    });
}

function cargarmfinal() {
    $.ajax({
        url: 'jsp/buscarmfinal.jsp',
        type: 'post',
        success: function (response) {
            $("#lbltotal").val(response.trim());
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar monto final: " + status + " - " + error);
        }
    });
}

function cargarmonto() {
    $.ajax({
        url: 'jsp/buscarmonto.jsp',
        type: 'post',
        success: function (response) {
            $("#m_inicial").val(response.trim());
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar monto inicial: " + status + " - " + error);
        }
    });
}

// Función para mostrar los detalles en la tabla y manejar la paginación
function mostrardetalles() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/movimientocaja.jsp',
        type: 'post',
        beforeSend: function () {
            // Limpiar la tabla antes de cargar nuevos datos
            $("#resultados").empty();
        },
        success: function (response) {
            console.log("Respuesta recibida:", response); // Log de depuración

            // Convertir la respuesta en un objeto jQuery para manipulación
            const tempDiv = $('<div>').html(response);
            allRows = tempDiv.find('tr');

            console.log("Número de filas encontradas:", allRows.length); // Log de depuración

            // Insertar todas las filas en la tabla para paginación
            paginate(allRows);
        },
        error: function (xhr, status, error) {
            console.error("Error AJAX:", error); // Log de depuración
            console.error("Estado:", status);
            console.error("Respuesta XHR:", xhr.responseText);
            mostrarAlerta("Error al cargar los movimientos: " + error, "alert-danger");
        }
    });
}

// Función para mostrar mensajes de alerta temporales
function mostrarAlerta(mensaje, tipo) {
    $("#mensajeAlerta")
        .removeClass()
        .addClass("alert " + tipo)
        .text(mensaje)
        .show()
        .fadeOut(3000, function () {
            $("#mensajeAlerta").html("");
        });
}

// Función para mostrar totales en la página
function mostrartotales() {
    $.ajax({
        data: {listar: 'mostrartotales'},
        url: 'jsp/insercionventas.jsp',
        type: 'post',
        success: function (response) {
            $("#lbltotal").html(response);
            $("#txtTotalCompra").val(response);
        }
    });
}
