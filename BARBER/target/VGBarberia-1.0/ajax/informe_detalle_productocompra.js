$(document).ready(function () {
    // Rellenar el select de clientes cuando la página carga
    rellenararticulo();

    // Manejo del botón de búsqueda
    $("#buscar").on('click', function (e) {
        e.preventDefault();
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_producto = $("#id_producto").val();  // Obtener el id del cliente

        // Verificar si se ha seleccionado un cliente
        var listar = (id_producto && id_producto !== "") ? 'listarcompra_producto' : 'listarcompra';

        // Enviar la solicitud AJAX al servidor
        $.ajax({
            data: {
                listar: listar, // Parámetro para indicar si se filtra por cliente o no
                fecha_desde: fecha_desde,
                fecha_hasta: fecha_hasta,
                id_producto: id_producto
            },
            url: 'jsp/informe_detalle_productocompra.jsp', // Ruta del JSP que procesará la solicitud
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

    // Manejo del botón para imprimir el reporte en formato PDF
    $("#imprimi").on('click', function () {
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        var id_producto = $("#id_producto").val();  // Obtener el id del cliente (si es necesario)

        window.open('jsp/informe_compras_productos.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                    '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                    '&id_producto=' + encodeURIComponent(id_producto), '_blank');
    });
    
    
});
