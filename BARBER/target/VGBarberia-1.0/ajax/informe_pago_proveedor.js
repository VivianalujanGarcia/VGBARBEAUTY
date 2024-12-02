$(document).ready(function () {
    // Rellenar el select de clientes cuando la página carga
    rellenaralumno();

    // Manejo del botón de búsqueda
    $("#buscar").on('click', function (e) {
        e.preventDefault();
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_proveedor = $("#id_proveedor").val();  // Obtener el id del cliente

        // Verificar si se ha seleccionado un cliente
        var listar = (id_proveedor && id_proveedor !== "") ? 'listarpago_proveedor' : 'listarpago';

        // Enviar la solicitud AJAX al servidor
        $.ajax({
            data: {
                listar: listar, // Parámetro para indicar si se filtra por cliente o no
                fecha_desde: fecha_desde,
                fecha_hasta: fecha_hasta,
                id_proveedor: id_proveedor
            },
            url: 'jsp/informe_pago_proveedor.jsp', // Ruta del JSP que procesará la solicitud
            type: 'post',
            success: function (response) {
                console.log(response);  // Verifica que la respuesta esté llegando correctamente
                $("#resultadosventas").html(response);  // Mostrar los resultados en el contenedor adecuado
                $("#Imprimirl").modal("show");  // Mostrar el modal con los resultados
                
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensajeAlerta").html("Error al procesar la solicitud.");
            }
        });
    });

    // Función para rellenar el select de clientes
    function rellenaralumno() {
        $.ajax({
            data: {listar: 'buscaralumno'},
            url: 'jsp/busquedaproveedor.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);  // Verifica que la respuesta sea correcta
                $("#id_proveedor").html(response);
            }
        });
    }

    // Manejo del botón para imprimir el reporte en formato PDF
    $("#imprimi").on('click', function () {
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_proveedor = $("#id_proveedor").val();  // Obtener el id del cliente (si es necesario)

        window.open('jsp/informe_pagos_proveedor.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                    '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                    '&id_proveedor=' + encodeURIComponent(id_proveedor), '_blank');
    });
});
