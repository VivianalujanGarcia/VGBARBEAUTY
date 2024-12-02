$(document).ready(function () {
    listadoclientesajax();
    cargarciudades();

    $("#boton").on('click', function () {
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/clientes.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarmensaje(response);
                    listadoclientesajax();
                    $("#mensaje").fadeOut(5000, function () {
                        $("#mensaje").html("");
                    });
                    $("#listar").val("cargar");
                    $("#pk").val("");
                    $("#nombre").val("");
                    $("#ci").val("");
                    $("#direccion").val("");
                    $("#telefono").val("");
                    $("#id_ciudad").val("");
                }
            });
        }
    });

    function validarFormulario() {
        var nombre = $("#nombre").val().trim();
        var ci = $("#ci").val().trim();
        var direccion = $("#direccion").val().trim();
        var telefono = $("#telefono").val().trim();
        var id_ciudad = $("#id_ciudad").val().trim();

        if (nombre === "") {
            mostraralert("Por favor, ingrese el nombre.", "alert-danger");
            return false;
        }
        if (ci === "") {
            mostraralert("Por favor, ingrese el ci.", "alert-danger");
            return false;
        }

        if (direccion === "") {
            mostraralert("Por favor, ingrese la direccion.", "alert-danger");
            return false;
        }
        if (id_ciudad === "") {
            mostraralert("Por favor, seleccione una ciudad.", "alert-danger");
            return false;
        }

        if (telefono === "") {
            mostraralert("Por favor, seleccione un telefono.", "alert-danger");
            return false;
        }

        return true;
    }

    function mostraralert(mensaje, tipo) {
        $("#mensajealer").removeClass().addClass("alert " + tipo).text(mensaje).show();
        $("#mensajealer").fadeOut(5000, function () {
            $("#mensajealer").html("");
        });
    }

    function mostrarmensaje(mensaje) {
        $("#mensaje").html(mensaje);
        $("#mensaje").fadeIn().delay(2000).fadeOut(2000, function () {
            $("#mensaje").html("");
        });
    }

    $("#eliminartodo").on('click', function () {
        pkdel = $("#pkdel").val();
        $.ajax({
            data: {listar: 'eliminar', pkdel: pkdel},
            url: 'jsp/clientes.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarmensaje(response);
                listadoclientesajax();
                $("#Eliminar").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
                $("#listar").val("cargar");
                $("#pk").val("");
                $("#nombre").val("");
                $("#ci").val("");
                $("#direccion").val("");
                $("#telefono").val("");
                $("#id_ciudad").val("");
            }
        });
    });

    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reportecliente.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/clientes.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoclientesajax();
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
        window.open('jsp/ListadoClientes.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/clientes.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoclientesajax();
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

});



function listadoclientesajax() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/clientes.jsp',
        type: 'post',
        success: function (response) {
            $("#resultado tbody").html(response);
        }
    });
    $("#listar").val("cargar");
    $("#pk").val("");
    $("#nombre").val("");
    $("#ci").val("");
    $("#direccion").val("");
    $("#telefono").val("");
    $("#id_ciudad").val("");
}

function rellenado(id, nombre, ci, direccion, telefono, nombre_ciudad) {
    $("#listar").val("modificar");
    $("#pk").val(id);
    $("#nombre").val(nombre);
    $("#ci").val(ci);
    $("#direccion").val(direccion);
    $("#telefono").val(telefono);
    $("#id_ciudad").val(nombre_ciudad);
}

function cargarciudades() {
    $.ajax({
        url: 'jsp/busciu.jsp',
        type: 'post',
        success: function (response) {
            $("#id_ciudad").html(response);
        }
    });
}
