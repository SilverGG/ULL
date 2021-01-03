/**
 * Universidad de La Laguna
 * Escuela Superior de Ingeniería y Tecnología
 * Grado en Ingeniería Informática
 * Informática Básica
 *
 * @author F. de Sande
 * @date 7.nov.2020
 * @brief Cada nuevo término de la serie de Fibonacci se genera sumando los dos anteriores. 
 *        Comenzando con 0 y 1, los primeros 10 términos serán: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
 *        Desarrolle en C++ un programa que calcule la suma de todos los términos de valor impar 
 *        de la serie que sean menores que uno dado.
 * @see https://docs.google.com/document/d/1-3hTIVf8tPrbn9u0vs0Cm2IGyX1XBgv8hReVU0KOSUQ/edit?usp=sharing
 * @see stoi http://www.cplusplus.com/reference/string/stoi/
 * An Object Oriented Version of the program:
 * @see https://stackoverflow.com/questions/21360694/sum-of-even-fibonacci-numbers-under-1000
 *
 */

#include <iostream>
#include <cstdlib>    // exit

#include "fibonacci_sum.h"    

/// Usage: the program requires a single numeric parameter
void Usage(int argc, char *argv[]) {
  if (argc != 2) {
    std::cout << argv[0] << ": Falta un número natural como parámetro" << std::endl;
    std::cout << "Pruebe " << argv[0] << " --help para más información" << std::endl;
    exit(EXIT_SUCCESS);
  }
  std::string parameter{argv[1]};
  if (parameter == "--help") {
    std::cout << kHelpText << std::endl;
    exit(EXIT_SUCCESS);
  }
}

/** Devuelve el valor de la suma de todos los términos de valor impar de la serie de
 *  Fibonacci menores que kLimit
 *
 *  @param[in] kLimit. Se suman los términos impares menores que kLimit
 *  @return La suma de los términos impares menores que kLimit
 */
size_t fibonacci_sum(const size_t kLimit) {
  size_t second_to_last{0},  // Second to last term
           last{1},          // Last term generated
           new_term;         // New term of the serie
  size_t long sum{1};        // Accumulated sum of the terms

  do {
    if (new_term % 2 != 0) {
      sum += new_term;
    }
    new_term = last + second_to_last;
    //Uncomment for debug: print each new term
    std::cout << "Term: " << new_term << std::endl;
    second_to_last = last;
    last = new_term;
  } while (new_term < kLimit);
	return sum;
}
