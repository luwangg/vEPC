/*
 * Copyright 2017-present Open Networking Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/********************************************************************20**

     Name:     TCP UDP Convergence Layer - test

     Type:     C source file

     Desc:     Sample C source code used to link TUCL in TRILLIUM 
               development environment.

     File:     hi_tst.c

     Sid:      hi_tst.c@@/main/5 - Mon Mar  3 20:09:58 2008

     Prg:      asa

*********************************************************************21*/


/* header include files (.h) */

#include "envopt.h"        /* environment options */  
#include "envdep.h"        /* environment dependent */
#include "envind.h"        /* environment independent */

#ifdef DOS                 /* dos environment */
#include <process.h>       /* dos - process */  
#endif

/* forward references */

#ifdef __cplusplus
extern "C" {
#endif

extern  int   main  ARGS((int argc, char **argv ));
extern  void  exit  ARGS((int status ));

#ifdef __cplusplus
}
#endif


/* functions */

/*
*
*       Fun:   Main
*
*       Desc:  Program execution starts here.
*
*       Ret:   None
*
*       Notes: None
*
*       File:  hi_tst.c
*
*/
#ifdef ANSI
int main
(
int      argc,                   /* argument count */
char   **argv                 /* argument values */
)
#else
int main(argc, argv)
int      argc;                   /* argument count */
char   **argv;                /* argument values */
#endif
{
   TRC1(main)

   exit(0);

   UNUSED(argc);
   UNUSED(argv);

   RETVALUE(OK);
} /* end of main */

  
/********************************************************************30**

         End of file:     hi_tst.c@@/main/5 - Mon Mar  3 20:09:58 2008

*********************************************************************31*/


/********************************************************************40**

        Notes:

*********************************************************************41*/

/********************************************************************50**

*********************************************************************51*/

   
/********************************************************************60**

        Revision history:

*********************************************************************61*/
/********************************************************************90**

     ver       pat    init                  description
------------ -------- ---- ----------------------------------------------
1.1          ---      asa  1. Initial Release.
/main/2               cvp  1. changed the copyright header.  
/main/3      ---      cvp  1. changed the copyright header.  
/main/4      ---       kp   1. Updated for release 1.5.
/main/5      ---       hs   1. Updated for release of 2.1
*********************************************************************91*/

