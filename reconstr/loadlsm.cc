// loadlsm : load LSM data

/*   This file is part of a software package written by 
     Rainer Heintzmann
     Institute of Applied Optics and Information Processing
     Albert Ueberle Strasse 3-5
     69120 Heidelberg
     Tel.: ++49 (0) 6221  549264
     Current Address : Max Planck Inst. for Biophysical Chemistry, Am Fassberg 11, 37077 Goettingen, Germany
     Tel.: ++49 (0) 551 201 1029, e-mail: rheintz@gwdg.de  or rainer@heintzmann.de
     No garantee, whatsoever is given about functionallaty and  savety.
     No warranty is taken for any kind of damage it may cause.
     No support for it is provided !

     THIS IS NOT FREE SOFTWARE. All rights are reserved, and the software is only
     given to a limited number of persons for evaluation purpose !
     Please do not modify and/or redistribute this file or any other files, libraries
     object files or executables of this software package !
*/

#include <iostream>
#include <string>
#include "rawarray.h"
#include "parseargs.h"

TArray3d<unsigned short> InputImg,* ROIImg=0, * DatROIImg=0;
TArray3d<unsigned char> InputBImg,* ROIBImg=0, * DatROIBImg=0;  // If 8-bits is selected, this 8-bit output will be used. otherwise conversion to 16 bit
TArray3d<double> * TimeStamps=0;

void usage(char * filename)
{
  cerr <<  "usage: " << filename << " [-k] [-s number] [-t] [-i inputfile] [-o outputfile] \n" << flush;
  exit(-1);
}


int main(int argc, char *argv[])
{ 
int Elements=1,i;
static int INPUTSizeX=32;  // These is the standart size, if raw data is used
static int INPUTSizeY=32;  // 256
static int INPUTSizeZ=32;  // 22
static int INPUTSizeT=1;  

bool kflag=false,Bits8=false,to12bits=false,noDisable=false;

int StartFrame=0,step=1,StopFrame=-1;
int StartTime=0,stepTime=1,StopTime=-1;
int elem=-1;  // means all elements
string INPUTFileName,OUTPUTFileName,ROIFileName,DatROIFileName,TimesFileName;

char ** parg= & argv[1];
argc=0;  // to prevent warning

 while (* parg)
  {
   if (readArg("-k",parg)) {kflag=true;continue;}
   if (readArg("-nodisable",parg)) {noDisable=true;continue;}
   if (readArg("-to12bit",parg)) {to12bits=true;continue;}
   if (readArg("-bits8",parg)) {Bits8=true;continue;}
   if (readArg("-i", & INPUTFileName, parg)) continue;
   if (readArg("-o", & OUTPUTFileName, parg)) continue;
   if (readArg("-roi", & ROIFileName, parg)) continue;
   if (readArg("-datroi", & DatROIFileName, parg)) continue;
   if (readArg("-ot", & TimesFileName, parg)) continue;
   if (readArg("-sX",& INPUTSizeX, parg)) continue;
   if (readArg("-sY",& INPUTSizeY,parg)) continue;
   if (readArg("-sZ",& INPUTSizeZ,parg)) continue;
   if (readArg("-sf",& StartFrame,parg)) continue;
   if (readArg("-stop",& StopFrame,parg)) continue;
   if (readArg("-step",& step,parg)) continue;
   if (readArg("-tsf",& StartTime,parg)) continue;
   if (readArg("-tstop",& StopTime,parg)) continue;
   if (readArg("-tstep",& stepTime,parg)) continue;
   if (readArg("-elem",& elem,parg)) continue;
    usage(argv[0]);
  }
  ofstream to(OUTPUTFileName.c_str());
  ofstream * timesfile=0;
  if (TimesFileName != "")
    {
    timesfile = new ofstream(TimesFileName.c_str());
    if (! timesfile )
      {
      cerr << "Couldn't open timestamp outputfile " << OUTPUTFileName << " for writing !!\n" << flush;
      exit(-1);
      }
      TimeStamps = new TArray3d<double>;
    }
      
  if (! to )
    {
      cerr << "Couldn't open file " << OUTPUTFileName << " for writing !!\n" << flush;
      exit(-1);
    }

  if (elem>= Elements) Elements=elem+1;
bool written=false;	  

  for (i=0;i<Elements;i++)
  {

  if (!to12bits)   // was Bits8
  {
    if (ROIFileName != "")
       ROIBImg= new TArray3d<unsigned char>;
    if (DatROIFileName != "")
       DatROIBImg= new TArray3d<unsigned char>;

    if (elem < 0 || i == elem)
    {
      cerr << "Element " << i << " processing\n" << flush;
    	Elements=InputBImg.LSMLoad(INPUTFileName.c_str(),INPUTSizeX,INPUTSizeY,INPUTSizeZ,INPUTSizeT,i,StartFrame,StopFrame,step,TimeStamps,
                                to12bits,ROIBImg, DatROIBImg,noDisable,StartTime,StopTime,stepTime);
    if (i == elem) Elements=1;
    if (!written)
      {InputBImg.DHeader(kflag,to,Elements,(StopTime-StartTime)/stepTime+1);
	written=true;
      }
    InputBImg.Write(& to);
    if (ROIFileName != "")
      ROIBImg->DSave(kflag,ROIFileName.c_str());
    if (DatROIFileName != "")
      DatROIBImg->DSave(kflag,DatROIFileName.c_str());
    }
  }
  else 
    {
    if (ROIFileName != "")
       ROIImg= new TArray3d<unsigned short>;
    if (DatROIFileName != "")
       DatROIImg= new TArray3d<unsigned short>;

    if (elem < 0 || i == elem)
    {
      cerr << "Element " << i << " processing\n" << flush;
        Elements=InputImg.LSMLoad(INPUTFileName.c_str(),INPUTSizeX,INPUTSizeY,INPUTSizeZ,INPUTSizeT,i,StartFrame,StopFrame,step,TimeStamps,
                                to12bits,ROIImg, DatROIImg,noDisable,StartTime,StopTime,stepTime);
    if (i == elem) Elements=1;

    if (!written)
      { InputImg.DHeader(kflag,to,Elements,(StopTime-StartTime)/stepTime+1);
	written=true;
      }

      InputImg.Write(& to);
    if (ROIFileName != "")
      ROIImg->DSave(kflag,ROIFileName.c_str());
    if (DatROIFileName != "")
      DatROIImg->DSave(kflag,DatROIFileName.c_str());
    }
    }

   if (i==0 && timesfile)
        TimeStamps->DHeader(kflag,* timesfile,Elements);

   if (timesfile)
       TimeStamps->Write(timesfile);

  }
  to.close();
  
  if (timesfile)
    timesfile->close();
}