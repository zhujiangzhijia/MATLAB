#ifndef parseargs_h		// -*- C++ -*- 
#define parseargs_h

/*   This file is part of a software package written by 
     Rainer Heintzmann
     Institute of Applied Optics and Information Processing
     Albert Ueberle Strasse 3-5
     69120 Heidelberg
     Tel.: ++49 (0) 6221  549264
     No garantee, whatsoever is given about functionallaty and  savety.
     No warranty is taken for any kind of damage it may cause.
     No support for it is provided !

     THIS IS NOT FREE SOFTWARE. All rights are reserved, and the software is only
     given to a limited number of persons for evaluation purpose !
     Please do not modify and/or redistribute this file or any other files, libraries
     object files or executables of this software package !
*/

#include <sstream>
#include <iostream>
#include <stdio.h>
#include <string.h>

using namespace std;

void printCall(int argc, char * argv[])
{
  int i;
  cout << "Call was :\n";
  for (i=0;i< argc;i++)
    {
      // cout << "\n" << i << "  ";
      cout << argv[i] << " ";
    }
  cout << "\n";
}

/// just parse a tag-string and return true if it is there.
int readArg(const char * TagString, char ** &argv)
{
    if (strcmp(* argv,TagString) != 0)
      return 0;
    else
      argv ++;
 //   cout << " Parsed switch tag\n";
    return 1;
}
 

/// parses a tag-string and any following variable-type into the variable Value. returns 1(true) if sucessful
template <class Targ>
int readArg(const char * TagString, Targ * Value, char ** &argv)
{
  char ** valwhere= argv;
  char tstchar;

  if (* valwhere == 0) return 0;

  if (TagString) {
    if (strcmp(* argv,TagString) != 0)
      {if (* TagString) return 0;}
    else
      valwhere ++;
  }

//  cout << " Parsed tag\n";
  if (* valwhere == 0) return 0;

  istringstream ist(* valwhere);
 // istrstream ist(* valwhere);

  if (! (ist >> (* Value)))
     return 0;

  // cout << " Parsed Value : " << (* Value) << "\n";

  if (ist >> tstchar)
    return 0;

//  cout << " Parsed succesfull\n";
  if (* TagString) argv += 2;
  else argv += 1;
  return 1;         // successfully parsed argument
}

int readArg(const char * TagString, char * Value, char ** &argv)  // special version for Strings reading the whole string
{
  char ** valwhere= argv;

  if (* valwhere == 0) return 0;

  if (TagString) {
    if (strcmp(* argv,TagString) != 0)
      {if (* TagString) return 0;}
    else
      valwhere ++;
  }

  // cout << " Parsed tag\n" << flush;
  if (* valwhere == 0) return 0;

  strcpy(Value,* valwhere);

  // printf(" Parsed Value : %s\n",Value);

//  cout << " Parsed succesfull\n";
  if (* TagString) argv += 2;
  else argv += 1;
  return 1;         // successfully parsed argument
}

int readArg(const char * TagString, string & Value, char ** &argv)  // special version for Strings reading the whole string
{
  char ** valwhere= argv;

  if (* valwhere == 0) return 0;

  if (TagString)
    if (strcmp(* argv,TagString) != 0)
      {if (* TagString) return 0;}
    else
      valwhere ++;

  // cout << " Parsed tag\n" << flush;
  if (* valwhere == 0) return 0;

  Value = (* valwhere); // copies the chars into the string

  // printf(" Parsed Value : %s\n",Value);

//  cout << " Parsed succesfull\n";
  if (* TagString) argv += 2;
  else argv += 1;
  return 1;         // successfully parsed argument
}


template <class Targ>
char * getVal(const char * tag, const char * filestr,Targ * Value, bool IgnoreIfAbsent=false)
{
  char * parse;
  if (tag == 0)
    {
      cerr << "Error : no tag given in getVal\n";
      exit(-1);
    }
    
  if (filestr == 0)
    {
      cerr << "Error : could not find tag before " << tag << "\n";
      exit(-1);
    }

  parse=strstr(filestr,tag);
  if (! parse) 
    {
      if (! IgnoreIfAbsent)
	{
	  cerr << "Fatal error: File does not contain tag " << tag << " \n";
	  exit(-1);
	} 
      else
	return (char *) filestr;  // as if nothing happened
    }
  istringstream ist(parse+strlen(tag));
  if (! (ist >> (* Value)))
    {
      cerr << "Fatal error: Value after tag '" << tag << "' has wrong dataformat !\n";
      exit(-1);
    }

  return parse;

}

#endif