$(document).ready(function () {
 listadoProveedoresAjax();
 cargarCiudades();

    $("#boton").on('click', function () {
        if (validarFormulario()) {
            var datosformulario = $("#form").serialize();
            $.ajax({
                data: datosformulario,
                url: 'jsp/proveedores.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    listadoProveedoresAjax();
                    limpiarFormulario();
                }
            });
        }
    });

    $("#eliminartodo").on('click', function () {
      
        pkdel = $("#pkdel").val();
        $.ajax({
            data: {listar: 'eliminar', pkdel: pkdel},
            url: 'jsp/proveedores.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProveedoresAjax();
                $("#Eliminar").modal("hide");
                limpiarFormulario();
            }
        });
    });
    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reporteproveedor.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/proveedores.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProveedoresAjax();
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
        window.open('jsp/ListadoProveedores.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/proveedores.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProveedoresAjax();
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

    function listadoProveedoresAjax() {
        $.ajax({
            url: 'jsp/proveedores.jsp',
            type: 'post',
            data: { listar: 'listar' },
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    function cargarCiudades() {
        $.ajax({
            url: 'jsp/busciu.jsp',
            type: 'post',
            success: function (response) {
                $("#id_ciudad").html(response);
            }
        });
    }

    function validarFormulario() {
        var nombre = $("#nombre").val().trim();
        var correo = $("#correo").val().trim();
        var ruc = $("#ruc").val().trim();
        var telefono = $("#telefono").val().trim();
        var id_ciudad = $("#id_ciudad").val().trim();

        if (nombre === "") {
            mostrarAlerta("Por favor, ingrese el nombre.", "alert-danger");
            return false;
        }
        if (correo === "") {
            mostrarAlerta("Por favor, ingrese el correo.", "alert-danger");
            return false;
        }
        if (ruc === "") {
            mostrarAlerta("Por favor, ingrese el RUC.", "alert-danger");
            return false;
        }
        if (telefono === "") {
            mostrarAlerta("Por favor, ingrese el teléfono.", "alert-danger");
            return false;
        }
        if (id_ciudad === "") {
            mostrarAlerta("Por favor, seleccione una ciudad.", "alert-danger");
            return false;
        }

        return true;
    }

    function mostrarAlerta(mensaje, tipo) {
        $("#mensajealerta").removeClass().addClass("alert " + tipo).text(mensaje).show();
        $("#mensajealerta").fadeOut(5000, function () {
            $("#mensajealerta").html("");
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
        $("#ruc").val("");
        $("#telefono").val("");
        $("#correo").val("");
        $("#id_ciudad").val("");
    }

     // Evento clic en botones de modificar
    $(document).on('click', '.btn-outline-success', function() {
        var id = $(this).closest('tr').find('td:eq(0)').text().trim();
        var nombre = $(this).closest('tr').find('td:eq(1)').text().trim();
        var ruc = $(this).closest('tr').find('td:eq(2)').text().trim();
        var telefono = $(this).closest('tr').find('td:eq(3)').text().trim();
        var correo = $(this).closest('tr').find('td:eq(4)').text().trim();
        var id_ciudad = $(this).closest('tr').find('td:eq(5)').text().trim();

        rellenado(id, nombre, ruc, telefono, correo, id_ciudad);
    });

    // Función para rellenar el formulario de modificar
    function rellenado(id, nombre, ruc, telefono, correo, id_ciudad) {
        $("#pk").val(id);
        $("#nombre").val(nombre);
        $("#ruc").val(ruc);
        $("#telefono").val(telefono);
        $("#correo").val(correo);
        $("#id_ciudad").val(id_ciudad);
        $("#listar").val("modificar");
    }

});
