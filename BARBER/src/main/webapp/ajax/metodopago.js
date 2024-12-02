$(document).ready(function () {
    // Función para cargar el listado de métodos de pago al cargar la página
    listadoMetodosPagoAjax();

    // Evento para manejar el formulario de agregar/modificar métodos de pago
    $("#boton").on('click', function () {      
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/metodopago.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    listadoMetodosPagoAjax(); // Actualiza la lista después de la operación
                    limpiarFormulario();
                }
            });
        }
    });

    // Evento para eliminar un método de pago
    $("#eliminartodo").on('click', function () {
        var pkdel = $("#pkdel").val();
        $.ajax({
            data: { listar: 'eliminar', pkdel: pkdel },
            url: 'jsp/metodopago.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoMetodosPagoAjax(); // Actualiza la lista después de la operación
                $("#Eliminar").modal("hide");
                limpiarFormulario();
            }
        });
    });
    
    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reportemetodo.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/metodopago.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoMetodosPagoAjax();
                $("#Imprimir").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensaje").html("Error al procesar la solicitud.");
            }
        });
    });




    $("#imprimi").on('click', function () {
        var pkim = $("pkim").val();
        window.open('jsp/ListadoMetodo.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/metodopago.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoMetodosPagoAjax();
                $("#Imprimirl").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensaje").html("Error al procesar la solicitud.");
            }
        });

    });

    // Evento para manejar la edición de un método de pago
    $(document).on('click', '.btn-outline-success', function() {
        var id = $(this).closest('tr').find('td:eq(0)').text().trim();
        var nombre = $(this).closest('tr').find('td:eq(1)').text().trim();
        rellenado(id, nombre);
    });

    // Función para obtener y mostrar el listado de métodos de pago
    function listadoMetodosPagoAjax() {
        $.ajax({
            url: 'jsp/metodopago.jsp',
            type: 'post',
            data: { listar: 'listar' },
            success: function (response) {
                $("#resultado tbody").html(response); // Inserta los datos en la tabla
            }
        });
    }

    // Función para validar el formulario antes de enviarlo
    function validarFormulario() {
        var metodo = $("#metodo").val().trim();
        if (metodo === "") {
            mostrarAlerta("Por favor, complete el campo de método de pago.", "alert-danger");
            return false;
        }
        return true;
    }

    // Función para mostrar alertas de mensajes
    function mostrarAlerta(mensaje, tipo) {
        $("#mensajealer").removeClass().addClass("alert " + tipo).text(mensaje).show();
        $("#mensajealer").fadeOut(5000, function () {
            $("#mensajealer").html("");
        });
    }

    // Función para mostrar mensajes generales
    function mostrarMensaje(mensaje) {
        $("#mensaje").html(mensaje);
        $("#mensaje").fadeIn().delay(2000).fadeOut(2000, function () {
            $("#mensaje").html("");
        });
    }

    // Función para limpiar el formulario después de operaciones
    function limpiarFormulario() {
        $("#listar").val("cargar");
        $("#pk").val("");
        $("#metodo").val("");
    }

    // Función para preparar el formulario con datos para modificar
    function rellenado(id, nom) {
        $("#listar").val("modificar");
        $("#metodo").val(nom);
        $("#pk").val(id);
    }
});
