$(document).ready(function () {
    // Rellenar los selects cuando la página carga
   rellenaralumno();  // Llenar el select de proveedores
    rellenarArticulo();   // Llenar el select de productos

    // Manejo del botón de búsqueda
    $("#buscar").on('click', function (e) {
        e.preventDefault();
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_producto = $("#id_producto").val();
        var id_proveedor = $("#id_proveedor").val(); // Obtener el id del proveedor

        // Verificar si se ha seleccionado un proveedor
        var listar = (id_producto && id_producto !== "") ? 'listardetallepago_producto' : 'listarpagodet';

        // Enviar la solicitud AJAX al servidor
        $.ajax({
            data: {
                listar: listar, // Parámetro para indicar si se filtra por producto
                fecha_desde: fecha_desde,
                fecha_hasta: fecha_hasta,
                id_producto: id_producto,
                id_proveedor: id_proveedor  // Enviar id_proveedor
            },
            url: 'jsp/informe_detalle_productopago.jsp', // Ruta del JSP que procesará la solicitud
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
    function rellenarArticulo() {
        $.ajax({
            data: {listar: 'buscaraarticulo'},  // Mantenemos la búsqueda de artículos como está
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
        var id_producto = $("#id_producto").val();  // Obtener id_producto si es necesario
        var id_proveedor = $("#id_proveedor").val();  // Obtener id_proveedor

        // Construir la URL del reporte
        var url = 'jsp/informe_detalle_pago.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                '&id_producto=' + encodeURIComponent(id_producto) +
                '&id_proveedor=' + encodeURIComponent(id_proveedor);  // Usamos id_proveedor aquí

        // Abrir la URL en una nueva pestaña para mostrar el reporte PDF
        window.open(url, '_blank');
    });
});
