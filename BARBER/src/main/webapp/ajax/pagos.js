$(document).ready(function () {
    listadopagosajax();

  function anularPago(id) {
       // Asigna el ID al input oculto
      $("#idpk").val(id);
    }
    function listadopagosajax() {
        $.ajax({
            data: { listar: 'listarpago' },
            url: 'jsp/buscadordetallepago.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadospagos").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", error);
                console.error("Detalles del error:", xhr.responseText);
                $("#resultadospagos").html("Error al cargar los datos.");
            }
        });
    }

    $("#imprimirtodo").on('click', function () {
        var pkim = $("#pkim").val();
        if (pkim) {
            window.open('jsp/reportepago.jsp?pkim=' + pkim, '_blank');
            $.ajax({
                data: { listar: ' ', pkim: pkim },
                url: 'jsp/detallepago.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    $("#Imprimir").modal("hide");
                    listadopagosajax();
                    $("#mensaje").fadeOut(2000, function () {
                        $("#mensaje").html("");
                    });
                },
                error: function (xhr, status, error) {
                    console.error("Error en la solicitud AJAX:", error);
                    console.error("Detalles del error:", xhr.responseText);
                    $("#mensaje").html("Error al procesar la solicitud.");
                }
            });
        } else {
            alert("No se ha seleccionado ningún registro para imprimir.");
        }
    });

    $("#imprimi").on('click', function () {
        window.open('jsp/ListadoPagos.jsp', '_blank');
        $.ajax({
            data: { listar: ' ' },
            url: 'jsp/buscadordetallepago.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#Imprimirl").modal("hide");
                listadopagosajax();
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", error);
                console.error("Detalles del error:", xhr.responseText);
                $("#mensaje").html("Error al procesar la solicitud.");
            }
        });
    });

    $("#btn-finalizar").click(function () {
        $.ajax({
            data: { listar: 'finalizar' }, 
            url: 'jsp/buscadordetallepago.jsp',
            type: 'post',
            success: function (response) {
                listadopagosajax();
            },
            error: function (xhr, status, error) {
                console.error("Error al finalizar el cobro:", error);
                console.error("Detalles del error:", xhr.responseText);
            }
        });
    });
});
$(document).ready(function () {
    $("#eliminar-registro-pago").click(function () {
        var pkd = $("#idpk").val();
        if (pkd) {
            $.ajax({
                data: {listar: 'anular', pkd: pkd},
                url: 'jsp/buscadordetallepago.jsp',
                type: 'post',
                success: function () {
                    $("#mensajeEstado").text("Registro anulado correctamente.").show().delay(3000).fadeOut();
                    listadopagosajax(); // Actualiza la lista de cobros
                    $("#exampleModal").modal("hide");
                },
                error: function (xhr, status, error) {
                    console.error("Error al eliminar el registro:", error);
                    $("#mensajeError").text("Error al intentar anular el registro.").show().delay(3000).fadeOut();
                }
            });
        } else {
            $("#mensajeError").text("ID no válido para eliminar.").show().delay(3000).fadeOut();
        }
    });
});