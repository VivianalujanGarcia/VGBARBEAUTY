$(document).ready(function () {
    // Manejar el clic en el botón para cerrar la caja
    $("#cerrarcaja").on('click', function () {
        // Deshabilitar el botón y mostrar un mensaje de carga
        var $btn = $(this);
        $btn.prop('disabled', true).val('Cerrando...');

        // Datos del formulario
        var datosFormulario = $("#form").serialize();
        
        // Mensaje de alerta limpio
        $("#mensajeAlerta").removeClass('alert-success alert-danger').fadeOut();
        
        // Realizar la solicitud AJAX
        $.ajax({
            url: 'jsp/cerrarcaja.jsp',  // Ruta de tu archivo JSP de procesamiento
            type: 'POST',
            data: datosFormulario,
            success: function (response) {
                // Mostrar el mensaje de éxito
                $("#mensajeAlerta").html(response).addClass('alert-success').fadeIn();
            },
            error: function () {
                // Mostrar el mensaje de error
                $("#mensajeAlerta").html('Error al cerrar la caja.').addClass('alert-danger').fadeIn();
            },
            complete: function () {
                // Rehabilitar el botón y restablecer su valor después de la solicitud
                $btn.prop('disabled', false).val('Cerrar Caja');
            }
        });
    });
});
