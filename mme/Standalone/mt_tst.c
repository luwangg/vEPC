/*
 * Copyright 2017-present Open Networking Laboratory
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
  
     Name:     MTSS-Solaris - test file
  
     Type:     C source file
  
     Desc:     Sample C source code required for building the
               MTSS-Solaris software at a customer site.

     File:     mt_tst.c

     Sid:      pt_tst.c@@/main/1 - Mon Apr  5 18:19:20 2010

     Prg:      ada

*********************************************************************21*/


/* header include files (.h) */

#include "envopt.h"        /* environment options */  
#include "envdep.h"        /* environment dependent */
#include "envind.h"        /* environment independent */

#include "gen.h"           /* general layer */
#include "ssi.h"           /* system services */


/* header/extern include files (.x) */
#include "gen.x"           /* general layer */
#include "ssi.x"           /* system services */



/* local defines */

/* local typedefs */

/* local externs */

/* forward references */

/* functions in other modules */
  
/* public variable declarations */
  
/* private variable declarations */



/*
*
*       Fun:   Test
*
*       Desc:  Prototype function for the function called before SS
*              begins its scheduling loop.
*
*       Ret:   None
*
*       Notes: None
*
*       File:  mt_tst.c
*
*/
#ifdef ANSI
PUBLIC S16 tst
(
void
)
#else
PUBLIC S16 tst()
#endif
{
   TRC1(tst);


   RETVALUE(OK);
} /* tst */


/*
*
*       Fun:   rdConQ
*
*       Desc:  Reads the console queue.
*
*       Ret:   None
*
*       Notes: None
*
*       File:  mt_tst.c
*
*/
#ifdef ANSI
PUBLIC S16 rdConQ
(
Data data
)
#else
PUBLIC S16 rdConQ(data)
Data data;
#endif
{
   TRC1(rdConQ);


   UNUSED(data);


   RETVALUE(OK);
} /* rdConQ */



/********************************************************************30**

         End of file:     pt_tst.c@@/main/1 - Mon Apr  5 18:19:20 2010

*********************************************************************31*/


/********************************************************************40**

        Notes:

*********************************************************************41*/

/********************************************************************50**

*********************************************************************51*/


/********************************************************************60**

        Revision history:

*********************************************************************61*/

/********************************************************************80**

  version    pat  init                   description
----------- ----- ----  ------------------------------------------------
1.1          ---  ada   1. initial release.

*********************************************************************81*/

/********************************************************************90**

     ver       pat    init                  description
------------ -------- ---- ----------------------------------------------
1.2          ---      kp   1. MTSS-Solaris release 2.1
/main/1      ---      ch   1. SSI Multicore Support release.
*********************************************************************91*/

