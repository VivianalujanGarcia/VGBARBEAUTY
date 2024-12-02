
    // Detectar el cambio en el método de pago
    $("#metodoModal").change(function () {
        var metodo = $(this).val();
        var montoTotal = $("#txtTotalCompra").val(); // Obtener el monto total desde el campo oculto

        console.log("Monto total desde txtTotalCompra:", montoTotal); // Para depuración

        // Verificar si el monto total está definido
        if (metodo === "QR") {
            if (!montoTotal || montoTotal == 0) {
                mostrarMensaje("El monto total no está definido o es 0.", "danger");
                return; // No continuar si el monto no está disponible
            }

            // Generar el QR dinámicamente
            $("#qrCode").empty(); // Limpiar cualquier QR anterior
            new QRCode(document.getElementById("qrCode"), {
                text: `Monto: ${montoTotal} Gs`, // Usamos el monto total de los totales
                width: 200,
                height: 200
            });
            $("#qrSection").show(); // Mostrar la sección QR
        } else {
            $("#qrSection").hide(); // Ocultar la sección QR si no es seleccionado
            $("#qrCode").empty();
        }
    });

    // Función para mostrar el mensaje
    function mostrarMensaje(texto, tipo) {
        // Limpiar cualquier mensaje anterior
        $("#mensaje").removeClass().addClass("alert alert-" + tipo).text(texto).show();

        // Ocultar el mensaje después de 5 segundos
        setTimeout(function () {
            $("#mensaje").fadeOut();
        }, 5000);
    }
 
 
 
 
 
 
 
 
 