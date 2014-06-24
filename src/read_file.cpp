#include <fstream>
#include <sstream>
#include <string>
#include <Rcpp.h>
using namespace Rcpp;

//' @importFrom Rcpp evalCpp
//' @useDynLib rsmith
// [[Rcpp::export]]
RawVector read_file(std::string path) {
  std::ifstream in(path.c_str(), std::ios::binary | std::ios::ate);
  size_t file_size=in.tellg();
  RawVector contents(file_size);
  std::string tmp;
  tmp.resize(file_size);
  in.seekg(0, std::ios::beg);
  in.read(&tmp[0], tmp.size());
  in.close();
  std::copy(tmp.begin(), tmp.end(), contents.begin());
  return(contents);
}
