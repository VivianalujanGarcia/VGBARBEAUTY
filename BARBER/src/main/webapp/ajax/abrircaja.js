  $(document).ready(function () {
            // Manejar el clic en el botón para abrir la caja
            $("#abrircaja").on('click', function () {
                var datosFormulario = $("#form").serialize();
                $.ajax({
                    url: 'jsp/abrircaja.jsp',
                    type: 'post',
                    data: datosFormulario,
                    success: function (response) {
                        $("#mensajeAlerta").html(response).addClass('alert-success').fadeIn();
                    },
                    error: function () {
                        $("#mensajeAlerta").html('Error al abrir la caja.').addClass('alert-danger').fadeIn();
                    }
                });
            });
    });
