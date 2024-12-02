$(document).ready(function () {
    $("#buscar").on('click', function (e) {
        e.preventDefault();
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
      

        $.ajax({
            data: {
                listar: 'listarventa', 
                fecha_desde: fecha_desde, 
                fecha_hasta: fecha_hasta
            },
            url: 'jsp/informe_venta_finalizado.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadosventas").html(response);
                $("#Imprimirl").modal("show");
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensajeAlerta").html("Error al procesar la solicitud.");
            }
        });
    });

    $("#imprimi").on('click', function () {
        var fecha_desde = $("#fecha_desde").val();
        var fecha_hasta = $("#fecha_hasta").val();
        window.open('jsp/informe_ventas_finalizado.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) + '&fecha_hasta=' + encodeURIComponent(fecha_hasta), '_blank');
    });
});
