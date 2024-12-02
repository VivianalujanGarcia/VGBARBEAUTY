$(document).ready(function () {
    listadoCategoriasAjax();

    $("#boton").on('click', function () {      
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/categorias.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    listadoCategoriasAjax();
                    limpiarFormulario();
                }
            });
        }
    });

    $("#eliminartodo").on('click', function () {
    
       var pkdel = $("#pkdel").val();
        $.ajax({
            data: { listar: 'eliminar', pkdel: pkdel },
            url: 'jsp/categorias.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoCategoriasAjax();
                $("#Eliminar").modal("hide");
                limpiarFormulario();
            }
        });
    });
    
    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reportecategoria.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/categorias.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoCategoriasAjax();
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
        window.open('jsp/ListadoCategorias.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/categorias.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoCategoriasAjax();
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
    $(document).on('click', '.btn-outline-success', function() {
        var id = $(this).closest('tr').find('td:eq(0)').text().trim();
        var nombre = $(this).closest('tr').find('td:eq(1)').text().trim();

        rellenado(id, nombre);
    });

    function listadoCategoriasAjax() {
        $.ajax({
            url: 'jsp/categorias.jsp',
            type: 'post',
            data: { listar: 'listar' },
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    function validarFormulario() {
        var nombre = $("#nombre").val().trim();
      
        if (nombre === "") {
            mostrarAlerta("Por favor, complete el campo de nombre.", "alert-danger");
            return false;
        }
        
        return true;
    }

    function mostrarAlerta(mensaje, tipo) {
        $("#mensajealer").removeClass().addClass("alert " + tipo).text(mensaje).show();
        $("#mensajealer").fadeOut(5000, function () {
            $("#mensajealer").html("");
        });
    }

    function mostrarMensaje(mensaje) {
        $("#mensaje").html(mensaje);
        $("#mensaje").fadeIn().delay(2000).fadeOut(2000, function () {
            $("#mensaje").html("");
        });
    }

    function limpiarFormulario() {
        $("#listar").val("cargar");
        $("#pk").val("");
        $("#nombre").val("");
    }

    function rellenado(id, nom) {
        $("#listar").val("modificar");
        $("#nombre").val(nom);
        $("#pk").val(id);
    }
    
});
