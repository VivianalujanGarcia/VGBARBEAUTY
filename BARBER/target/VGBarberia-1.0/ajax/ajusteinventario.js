$(document).ready(function () {
    rellenararticulo();
    listarajuste();
 

    function listarajuste() {
        $.ajax({
            data: { listar: 'listarajuste' },
            url: 'jsp/insercioninventario.jsp',
            type: 'post',
            beforeSend: function () {
                // Mostrar indicador de carga si lo deseas
            },
            success: function (response) {
                $("#resultadoajuste").html(response);
                asignarEventosEliminarajuste();
            },
            error: function (xhr, status, error) {
                console.error('Error al cargar los ajustes:', error);
            }
        });
    }

    // Función para asignar eventos de clic a los botones de eliminar ajuste
    function asignarEventosEliminarajuste() {
        $(".eliminar-ajuste").click(function () {
            var idajusteinve = $(this).data("id");
            $("#idpk").val(idajusteinve); // Establecer el id del ajuste en el campo oculto del modal
        });

        $("#imprimirtodo").on('click', function () {
            var pk = $("#pkim").val();
            window.open('jsp/ListadoVentas.jsp?pkim=' + pk, '_blank');
            $.ajax({
                data: { listar: ' ', pkim: pk },
                url: 'jsp/insercionventas.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    listarajuste(); // Asegúrate de actualizar la lista de ajustes después de imprimir
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

        // Evento para confirmar la eliminación del ajuste
        $("#eliminar-registro-detalleajus").click(function () {
            var pkd = $("#idpk").val();
            $.ajax({
                data: {listar: 'anularajuste', pkd: pkd},
                url: 'jsp/insercioninventario.jsp',
                type: 'post',
                success: function (response) {
                    // Muestra el mensaje de respuesta
                    $("#mensaje").html(response);
                    $('#exampleModal').modal('hide'); // Reemplaza 'miModal' con el ID de tu modal
                    listarajuste();
                },
                error: function (xhr, status, error) {
                    console.error('Error en la eliminación:', error);
                    $("#mensaje").html("Error al anular el ajuste. Por favor, inténtalo de nuevo.");
                }
            });
        });

    }

    $("#AgregaProducto").click(function () {
        //calcularCantidadActual();
        var datosform = $("#form").serialize();
        $.ajax({
            data: datosform,
            url: 'jsp/insercioninventario.jsp',
            type: 'post',
            success: function (response) {
                console.log();
              
                $("#respuesta").html(response);
                mostrardetalles();
            }
        });
    });

    $("#eliminar-registro-detalle").click(function () {
        var pk = $("#idpk").val();
        $.ajax({
            data: {listar: 'eliminardetalle', pk: pk},
            url: 'jsp/insercioninventario.jsp',
            type: 'post',
            success: function (response) {
                mostrardetalles();
            },
            error: function (xhr, status, error) {
                console.error('Error en la eliminación:', error);
            }
        });
    });

    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelarajuste'},
            url: 'jsp/insercioninventario.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'listarajuste.jsp';
            }
        });
    });

  $("#btn-finalizar").click(function () {
    $.ajax({
        data: { listar: 'finalizarajuste' },
        url: 'jsp/insercioninventario.jsp',
        type: 'post',
        success: function (response) {
            // Suponiendo que `response` contiene el mensaje de validación en formato HTML
            $("#mensaje-validacion").html(response).addClass('alert-success').show();
            // Redirecciona después de un tiempo si es necesario
            setTimeout(function() {
                location.href = 'listarajuste.jsp';
            }, 2000); // Redirecciona después de 2 segundos
        },
        error: function (xhr, status, error) {
            console.error('Error al finalizar el ajuste:', error);
            $("#mensaje-validacion").html("Ocurrió un error al finalizar el ajuste. Inténtalo de nuevo.").addClass('alert-danger').show();
        }
    });
});



    $("#idproductos").change(function () {
        dividirproducto(this.value);
        calcularCantidadActual();
    });

    $("#cantidad_actual").on('input', function () {
        calcularCantidadActual();
    });

    $("#tipo").change(function () {
        calcularCantidadActual();
    });



});


function rellenararticulo() {
    $.ajax({
        data: {listar: 'buscaraarticulo'},
        url: 'jsp/busquedainven.jsp',
        type: 'post',
        beforeSend: function () {
            //$("#resultado").html("Procesando, espere por favor...");
        },
        success: function (response) {
            $("#id_producto").html(response);
        }
    });
}

function dividirproducto(a) {
    //alert(a)
    datos = a.split(',');
    // alert(datos[0]);
    //alert(datos[1]);
    $("#codproducto").val(datos[0]);
    $("#cantidad").val(datos[1]);
    //buscarprecio();
}




function calcularCantidadActual() {
    var cantidad = parseInt($("#cantidad").val()) || 0;
    var cant_ajuste = parseInt($("#cant_ajuste").val()) || 0;
    var nuevaCantidad = parseInt($("#cant_actual").val()) || 0;
    var tipo = $("#tipo").val();

    if (tipo === "aumento") {
        nuevaCantidad = cantidad + cant_ajuste;
    } else if (tipo === "descuento") {
        nuevaCantidad = cantidad - cant_ajuste;
    }

    if (!isNaN(nuevaCantidad)) {
        $("#cant_actual").val(nuevaCantidad);
    }
}


function mostrardetalles() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/insercioninventario.jsp',
        type: 'post',
        success: function (response) {
            $("#resultados").html(response);
        },
        error: function (xhr, status, error) {
            console.error('Error al mostrar detalles:', error);
        }
    });
}


