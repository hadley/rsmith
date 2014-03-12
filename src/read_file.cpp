#include <fstream>
#include <sstream>
#include <string>
#include <Rcpp.h>
using namespace Rcpp;

//' @importFrom Rcpp evalCpp
//' @useDynLib rsmith
// [[Rcpp::export]]
CharacterVector read_file(std::string path) {
  std::ifstream in(path.c_str());
  std::string contents;
  in.seekg(0, std::ios::end);
  contents.resize(in.tellg());
  in.seekg(0, std::ios::beg);
  in.read(&contents[0], contents.size());
  in.close();
  return(contents);
}
