$(document).ready(function () {
    // Rellenar el select de clientes cuando la página carga
   rellenaralumno();
    rellenararticulo();

    // Manejo del botón de búsqueda
    $("#buscar").on('click', function (e) {
        e.preventDefault();
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_producto = $("#id_producto").val();
        var id_cliente = $("#id_cliente").val();// Obtener el id del cliente

        // Verificar si se ha seleccionado un cliente
        var listar = (id_producto && id_producto !== "") ? 'listardetallecobro_producto' : 'listarcobrodet';

        // Enviar la solicitud AJAX al servidor
        $.ajax({
            data: {
                listar: listar, // Parámetro para indicar si se filtra por cliente o no
                fecha_desde: fecha_desde,
                fecha_hasta: fecha_hasta,
                id_producto: id_producto,
                id_cliente: id_cliente
            },
            url: 'jsp/informe_detalle_productocobro.jsp', // Ruta del JSP que procesará la solicitud
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
      // Función para rellenar el select de productos
    function rellenararticulo() {
        $.ajax({
            data: {listar: 'buscaraarticulo'},
            url: 'jsp/busquedaproveedor.jsp',
            type: 'post',
            success: function (response) {
                $("#id_producto").html(response);
            }
        });
    }

      // Función para rellenar el select de clientes
    function rellenaralumno() {
        $.ajax({
            data: {listar: 'buscaralumno'},
            url: 'jsp/busquedacliente.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);  // Verifica que la respuesta sea correcta
                $("#id_cliente").html(response);
            }
        });
    }

    // Manejo del botón para imprimir el reporte en formato PDF
    $("#imprimi").on('click', function () {
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_producto = $("#id_producto").val();  // Obtener id_producto si es necesario
        var id_cliente = $("#id_cliente").val();  // Obtener id_cliente

        // Construir la URL del reporte
        var url = 'jsp/informe_detalle_cobro.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                '&id_producto=' + encodeURIComponent(id_producto) +
                '&id_cliente=' + encodeURIComponent(id_cliente);

        // Abrir la URL en una nueva pestaña para mostrar el reporte PDF
        window.open(url, '_blank');
    });

});
