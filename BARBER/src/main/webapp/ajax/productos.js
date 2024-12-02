$(document).ready(function () {
    listadoProductosAjax();
    cargarcat();
    cargarmarc();
    //marcanombre();
    $("#boton").on('click', function () {
        if (validarFormulario()) {
            var datosFormulario = $("#form").serialize();
            $.ajax({
                data: datosFormulario,
                url: 'jsp/productos.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    listadoProductosAjax();
                    limpiarFormulario();
                }
            });
        }
    });

    function validarFormulario() {
        var nombre = $("#nombre").val().trim();
        var descripcion = $("#descripcion").val().trim();
        var precio = $("#precio").val().trim();
        var cantidad = $("#cantidad").val().trim();
        var id_categoria = $("#id_categoria").val().trim();
        var id_marca = $("#id_marca").val().trim();
        var iva = $("#iva").val().trim();

        if (nombre === "") {
            mostrarAlerta("Por favor, complete el campo de nombre.", "alert-danger");
            return false;
        }
        if (descripcion === "") {
            mostrarAlerta("Por favor, complete el campo de descripción.", "alert-danger");
            return false;
        }
        if (precio === "") {
            mostrarAlerta("Por favor, complete el campo de precio.", "alert-danger");
            return false;
        }
        if (cantidad === "") {
            mostrarAlerta("Por favor, complete el campo de cantidad.", "alert-danger");
            return false;
        }
        if (id_categoria === "") {
            mostrarAlerta("Por favor, complete el campo de categoría ID.", "alert-danger");
            return false;
        }
        if (id_marca === "") {
            mostrarAlerta("Por favor, complete el campo de marca ID.", "alert-danger");
            return false;
        }
        if (iva === "") {
            mostrarAlerta("Por favor, complete el campo de iva.", "alert-danger");
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
        $("#form")[0].reset();
    }

    $("#eliminartodo").on('click', function () {

        var pkdel = $("#pkdel").val();
        $.ajax({
            data: {listar: 'eliminar', pkdel: pkdel},
            url: 'jsp/productos.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProductosAjax();
                limpiarFormulario();
            }
        });
    });

    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        window.open('jsp/reporteproducto.jsp?pkim=' + pkim, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/productos.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProductosAjax();
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
        window.open('jsp/ListadoProductos.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/productos.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listadoProductosAjax();
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




    function listadoProductosAjax() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/productos.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);

                // Ahora recorremos las filas de la tabla para verificar el stock de cada producto
                $("#resultado tbody tr").each(function () {
                    var cantidad = parseInt($(this).find("td:eq(4)").text().trim());

                    // Define el umbral mínimo de stock
                    var stockMinimo = 10; // Aquí puedes ajustar el valor según lo necesites

                    if (cantidad <= stockMinimo) {
                        var productoNombre = $(this).find("td:eq(1)").text().trim(); // Nombre del producto
                        // Muestra un mensaje de alerta si el stock es bajo
                        mostrarAlerta("¡Atención! El producto " + productoNombre + " está por debajo del stock mínimo (" + cantidad + " unidades).", "alert-warning");
                    }
                });
            }
        });
    }


    // Función para rellenar los campos al hacer clic en el botón de editar
    function rellenado(id, nom, desc, precio, cantidad, id_categoria, id_marca, iva) {
        $("#listar").val("modificar");
        $("#pk").val(id);
        $("#nombre").val(nom);
        $("#descripcion").val(desc);
        $("#precio").val(precio);
        $("#cantidad").val(cantidad);

        // Asegúrate de que las categorías y marcas se asignen correctamente
        $("#id_categoria").val(id_categoria); // Selecciona la categoría correspondiente
        $("#id_marca").val(id_marca); // Selecciona la marca correspondiente

        // Asegúrate de que el IVA se selecciona correctamente
        $("#iva").val(iva); // Selecciona el IVA correspondiente
        cargarcat();
        cargarmarc();
    }


// Evento para activar la función de rellenado al hacer clic en el botón de editar
    $(document).on('click', '.btn-outline-success', function () {
        var id = $(this).closest('tr').find('td:eq(0)').text().trim();
        var nombre = $(this).closest('tr').find('td:eq(1)').text().trim();
        var descripcion = $(this).closest('tr').find('td:eq(2)').text().trim();
        var precio = $(this).closest('tr').find('td:eq(3)').text().trim();
        var cantidad = $(this).closest('tr').find('td:eq(4)').text().trim();
        var id_categoria = $(this).closest('tr').find('td:eq(5)').text().trim();
        var id_marca = $(this).closest('tr').find('td:eq(6)').text().trim();
        var iva = $(this).closest('tr').find('td:eq(7)').text().trim();

        rellenado(id, nombre, descripcion, precio, cantidad, id_categoria, id_marca, iva);
        cargarcat();
        cargarmarc();
    });
    function cargarcat() {
        $.ajax({
            url: 'jsp/buscat.jsp',
            type: 'post',
            success: function (response) {
                $("#id_categoria").html(response);
            }
        });
    }
    function cargarmarc() {
        $.ajax({
            url: 'jsp/buscmar.jsp',
            type: 'post',
            success: function (response) {
                $("#id_marca").html(response);
            }
        });
    }

});
