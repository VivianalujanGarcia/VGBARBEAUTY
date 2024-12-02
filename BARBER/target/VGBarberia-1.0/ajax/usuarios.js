$(document).ready(function() {
    listadousuariosajax();

    $("#boton").on('click', function() {
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/usuarios.jsp',
                type: 'post',
                success: function(response) {
                    $("#mensaje").html(response);
                    mostrarmensaje(response);
                    listadousuariosajax();
                    limpiarFormulario();
                }
            });
        }
    });

    function rellenado(id, nom, co, clav, tp, es) {
        $("#listar").val("modificar");
        $("#pk").val(id);
        $("#datos").val(nom);
        $("#usuario").val(co);
        $("#clave").val(clav);
        $("#rol").val(tp);
        $("#estado").val(es);
    }

    $(document).on('click', '.btn-outline-success', function() {
        var id = $(this).closest('tr').find('td:eq(0)').text().trim();
        var datos = $(this).closest('tr').find('td:eq(1)').text().trim();
        var usuario = $(this).closest('tr').find('td:eq(2)').text().trim();
        var clave = $(this).closest('tr').find('td:eq(3)').text().trim();
        var rol = $(this).closest('tr').find('td:eq(4)').text().trim();
        var estado = $(this).closest('tr').find('td:eq(5)').text().trim();

        rellenado(id, datos, usuario, clave, rol, estado);
    });

    $("#eliminartodo").on('click', function() {
        var pkdel = $("#pkdel").val();
        $.ajax({
            data: { listar: 'eliminar', pkdel: pkdel },
            url: 'jsp/usuarios.jsp',
            type: 'post',
            success: function(response) {
                $("#mensaje").html(response);
                mostrarmensaje(response);
                listadousuariosajax();
                limpiarFormulario();
            }
        });
    });
     
    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reporteusuario.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/usuarios.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadousuariosajax();
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
        window.open('jsp/ListadoUsuario.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/usuarios.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadousuariosajax();
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
    function validarFormulario() {
        var datos = $("#datos").val().trim();
        var usuario = $("#usuario").val().trim();
        var clave = $("#clave").val().trim();
        var rol = $("#rol").val().trim();
        var estado = $("#estado").val().trim();

        if (datos === "") {
            mostraralert("Por favor, complete el campo de datos.", "alert-danger");
            return false;
        }
        if (usuario === "") {
            mostraralert("Por favor, complete el campo de usuario.", "alert-danger");
            return false;
        }
        if (clave === "") {
            mostraralert("Por favor, complete el campo de contraseña.", "alert-danger");
            return false;
        }
        if (rol === "") {
            mostraralert("Por favor, seleccione el rol de usuario.", "alert-danger");
            return false;
        }
        if (estado === "") {
            mostraralert("Por favor, seleccione el estado del usuario.", "alert-danger");
            return false;
        }
        return true;
    }

    function mostraralert(mensaje, tipo) {
        $("#mensajealer").removeClass().addClass("alert " + tipo).text(mensaje).show();
        $("#mensajealer").fadeOut(5000, function() {
            $("#mensajealer").html("");
        });
    }

    function mostrarmensaje(mensaje) {
        $("#mensaje").html(mensaje);
        $("#mensaje").fadeIn().delay(2000).fadeOut(2000, function() {
            $("#mensaje").html("");
        });
    }

    function listadousuariosajax() {
        $.ajax({
            data: { listar: 'listar' },
            url: 'jsp/usuarios.jsp',
            type: 'post',
            success: function(response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    function limpiarFormulario() {
        $("#listar").val("cargar");
        $("#pk").val("");
        $("#datos").val("");
        $("#usuario").val("");
        $("#clave").val("");
        $("#rol").val("");
        $("#estado").val("");
    }
});
