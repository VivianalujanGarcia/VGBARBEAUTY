package com.mycompany.conversor;

public class NumeroALetra {
    private static final String[] unidades = {
        "", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez",
        "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"
    };

    private static final String[] decenas = {
        "", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"
    };

    private static final String[] centenas = {
        "", "cien", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"
    };

    public static String convertir(int numero) {
        if (numero == 0) {
            return "cero";
        }

        if (numero < 0) {
            return "menos " + convertir(-numero);
        }

        String resultado = "";

        // Manejar los números mayores a 1,000,000 (millones)
        if (numero >= 1000000) {
            if (numero >= 2000000) {
                resultado += convertir(numero / 1000000) + " millones ";
            } else {
                resultado += "un millón ";
            }
            numero %= 1000000;
        }

        // Manejar los números mayores a 999 (miles)
        if (numero >= 1000) {
            if (numero >= 2000) {
                resultado += convertir(numero / 1000) + " mil ";
            } else {
                resultado += "mil ";
            }
            numero %= 1000;
        }

        //manejar las centenas
       if (numero >= 100) {
         if (numero == 100) {
            resultado += "cien ";
         } else {
            resultado += centenas[numero / 100] + (numero % 100 > 0 ? "to " : " ");
         }
             numero %= 100;
       }

        // Manejar las decenas y agregar "y" entre decenas y unidades cuando sea necesario
        if (numero >= 20) {
            resultado += decenas[numero / 10];
            int unidad = numero % 10;
            if (unidad > 0) {
                resultado += " y " + unidades[unidad] + " ";
            } else {
                resultado += " ";
            }
            numero = 0;  // Ya procesamos las unidades
        }

        // Manejar las unidades (para números menores a 20 o si quedan unidades)
        if (numero > 0) {
            resultado += unidades[numero] + " ";
        }

        return resultado.trim();
    }
}

/*
public class NumeroALetra {
    private static final String[] unidades = {
        "", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez",
        "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"
    };

    private static final String[] decenas = {
        "", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"
    };

    private static final String[] centenas = {
        "", "cien", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"
    };

    public static String convertir(int numero) {
        if (numero == 0) {
            return "cero";
        }

        if (numero < 0) {
            return "menos " + convertir(-numero);
        }

        String resultado = "";

        // Manejar los números mayores a 999 (miles)
        if (numero >= 1000) {
            if (numero >= 2000) {
                resultado += convertir(numero / 1000) + " mil ";
            } else {
                resultado += "mil ";
            }
            numero %= 1000;
        }
		//manejar las centenas
       if (numero >= 100) {
         if (numero == 100) {
            resultado += "cien ";
         } else {
            resultado += centenas[numero / 100] + (numero % 100 > 0 ? "to " : " ");
         }
             numero %= 100;
       }

        // Manejar las decenas
        if (numero >= 20) {
            resultado += decenas[numero / 10] + " ";
            numero %= 10;
        }

        // Manejar las unidades
        if (numero > 0) {
            resultado += unidades[numero] + " ";
        }

        return resultado.trim();
    }

    public static void main(String[] args) {
        System.out.println(convertir(153));   // ciento cincuenta y tres
        System.out.println(convertir(1000));  // mil
        System.out.println(convertir(2001));  // dos mil uno
        System.out.println(convertir(999));   // novecientos noventa y nueve
    }
}
*/