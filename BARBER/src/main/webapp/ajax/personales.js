$(document).ready(function () {
    listadopersonalesajax();
    cargarciudades();

    $("#boton").on('click', function () {
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/personales.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarmensaje(response);
                    listadopersonalesajax();
                    $("#mensaje").fadeOut(5000, function () {
                        $("#mensaje").html("");
                    });
                    $("#listar").val("cargar");
                    $("#pk").val("");
                    $("#nombre").val("");
                    $("#apellido").val("");
                    $("#ci").val("");
                    $("#fecha").val("");
                    $("#direccion").val("");
                    $("#telefono").val("");
        
                    $("#id_ciudad").val("");
                }
            });
        }
    });

    function validarFormulario() {
        var nombre = $("#nombre").val().trim();
        var apellido = $("#apellido").val().trim();
        var ci = $("#ci").val().trim();
        var fecha = $("#fecha").val().trim();
        var direccion = $("#direccion").val().trim();
        var telefono = $("#telefono").val().trim();
        var id_ciudad = $("#id_ciudad").val().trim();
  

        if (nombre === "") {
            mostraralert("Por favor, ingrese el nombre.", "alert-danger");
            return false;
        }
        if (apellido === "") {
            mostraralert("Por favor, ingrese el apellido.", "alert-danger");
            return false;
        }
        if (ci === "") {
            mostraralert("Por favor, ingrese el CI.", "alert-danger");
            return false;
        }
        if (fecha === "") {
            mostraralert("Por favor, ingrese la fecha de nacimiento.", "alert-danger");
            return false;
        }
        if (direccion === "") {
            mostraralert("Por favor, ingrese la dirección.", "alert-danger");
            return false;
        }
        if (telefono === "") {
            mostraralert("Por favor, ingrese el teléfono.", "alert-danger");
            return false;
        }
        if (id_ciudad === "") {
            mostraralert("Por favor, seleccione una ciudad.", "alert-danger");
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
            url: 'jsp/personales.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarmensaje(response);
                listadopersonalesajax();
                $("#Eliminar").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
                $("#listar").val("cargar");
                $("#pk").val("");
                $("#nombre").val("");
                $("#apellido").val("");
                $("#ci").val("");
                $("#fecha").val("");
                $("#direccion").val("");
                $("#telefono").val("");
             
                $("#id_ciudad").val("");
            }
        });
    });
    
   $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reportepersonal.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/personales.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadopersonalesajax();
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
        window.open('jsp/ListadoPersonales.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/personales.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadopersonalesajax();
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



function listadopersonalesajax() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/personales.jsp',
        type: 'post',
        success: function (response) {
            $("#resultado tbody").html(response);
        }
    });
    $("#listar").val("cargar");
    $("#pk").val("");
    $("#nombre").val("");
    $("#apellido").val("");
    $("#ci").val("");
    $("#fecha").val("");
    $("#direccion").val("");
    $("#telefono").val("");
  
    $("#id_ciudad").val("");
}

function rellenado(id, nombre, apellido, ci, fecha, direccion, telefono,  id_ciudad) {
    $("#listar").val("modificar");
    $("#pk").val(id);
    $("#nombre").val(nombre);
    $("#apellido").val(apellido);
    $("#ci").val(ci);
    $("#fecha").val(fecha);
    $("#direccion").val(direccion);
    $("#telefono").val(telefono);

    $("#id_ciudad").val(id_ciudad);
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
