$(document).ready(function () {
    listadoejercicioajax();
    cargarlec();

    $("#boton").on('click', function () {
        $("#tipo").val().trim().toUpperCase();
        $("#pregunta").val().trim().toUpperCase();
        $("#respuestacorrecta").val().trim().toUpperCase();
        $("#opcionesrespuesta").val().trim().toUpperCase();
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/ejercicio.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarmensaje(response);
                    listadoejercicioajax();
                    $("#mensaje").fadeOut(5000, function () {
                        $("#mensaje").html("");
                    });
                    $("#listar").val("cargar");
                    $("#pk").val("");
                    $("#tipo").val("");
                    $("#pregunta").val("");
                    $("#respuestacorrecta").val("");
                    $("#opcionesrespuesta").val("");
                    $("#puntuacionalcanzada").val("");
                    $("#idleccion").val("");
                }
            });
        }
    });
    
    
    function validarFormulario() {
        var tipo = $("#tipo").val().trim();
        var pregunta = $("#pregunta").val().trim();
        var respuestacorrecta = $("#respuestacorrecta").val().trim();
        var opcionesrespuesta = $("#opcionesrespuesta").val().trim();
        var puntuacionalcanzada = $("#puntuacionalcanzada").val().trim();
        var idleccion = $("#idleccion").val().trim();

        if (tipo === "") {
            mostraralert("Por favor, complete el campo de tipo.", "alert-danger");
            return false;
        }
        if (pregunta === "") {
            mostraralert("Por favor, complete el campo de pregunta.", "alert-danger");
            return false;
        }
        if (respuestacorrecta === "") {
            mostraralert("Por favor, complete el campo de respuesta correcta.", "alert-danger");
            return false;
        }
        if (opcionesrespuesta === "") {
            mostraralert("Por favor, complete el campo de opciones respuesta.", "alert-danger");
            return false;
        }
        if (puntuacionalcanzada === "") {
            mostraralert("Por favor, complete el campo de puntuacion obtenida.", "alert-danger");
            return false;
        }
        if (idleccion === "") {
            mostraralert("Por favor,  seleccione una leccion.", "alert-danger");
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
            url: 'jsp/ejercicio.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarmensaje(response);
                listadoejercicioajax();
                $("#Eliminar").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
                $("#listar").val("cargar");
                $("#pk").val("");
                $("#tipo").val("");
                $("#pregunta").val("");
                $("#respuestacorrecta").val("");
                $("#opcionesrespuesta").val("");
                $("#puntuacionalcanzada").val("");
                $("#idleccion").val("");
            }
        });
    });

});
function listadoejercicioajax() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/ejercicio.jsp',
        type: 'post',
        success: function (response) {
            $("#resultado tbody").html(response);
        }
    });
    $("#listar").val("cargar");
    $("#pk").val("");
    $("#tipo").val("");
    $("#pregunta").val("");
    $("#respuestacorrecta").val("");
    $("#opcionesrespuesta").val("");
    $("#puntuacionalcanzada").val("");
    $("#idleccion").val("");
}

function rellenado(id, tip, pre, res, op, pun, fklec) {
//alert(id);
    $("#listar").val("modificar");
    $("#tipo").val(tip);
    $("#pregunta").val(pre);
    $("#respuestacorrecta").val(res);
    $("#opcionesrespuesta").val(op);
    $("#puntuacionalcanzada").val(pun);
    $("#idleccion").val(fklec);
    $("#pk").val(id);
}

function cargarlec() {
    $.ajax({
        url: 'jsp/busleccion.jsp',
        type: 'post',
        success: function (response) {
            $("#idleccion").html(response);
        }
    });
}


