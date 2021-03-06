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

     Name:    Trillium LTE SGW Application 

     Type:    C Include file

     Desc:    This file contains utility functions for SGW

     File:    qosm_utl.c

     Sid:      qosm_utl.c@@/main/1 - Thu Jul  8 21:22:23 2010

     Prg:       sp     
*********************************************************************21*/

#include "envopt.h"        /* environment options */
#include "envdep.h"        /* environment dependent */
#include "envind.h"        /* environment independent */

#include "gen.h"           /* general layer */
#include "ssi.h"           /* system services */
#include "cm5.h"           /* common timers defines */
#include "cm_hash.h"       /* common hash list defines */
#include "cm_inet.h"       /* common INET defines */
#include "cm_llist.h"      /* common linked list defines */
#include "cm_mblk.h"       /* memory management */
#include "cm_tkns.h"       /* common tokens */
#include "cm_tpt.h"        /* common transport defines */
#include "cm_dns.h"         /* common DNS libraru defines */

#ifdef HI
#include "lhi.h"
#include "hit.h"           /* HI layer */
#include "hi.h"
#endif

#include "lqo.h"
#include "qosm.h"        /* defines for S1AP acceptance tests */

/* header/extern include files (.x) */

#include "gen.x"           /* general layer typedefs */
#include "ssi.x"           /* system services typedefs */
#include "cm5.x"           /* common timers */
#include "cm_hash.x"       /* common hash list */
#include "cm_inet.x"       /* common INET */
#include "cm_lib.x"        /* common library */
#include "cm_llist.x"      /* common linked list */
#include "cm_mblk.x"       /* memory management */
#include "cm_tkns.x"       /* common tokens */
#include "cm_tpt.x"        /* common transport types */
#include "cm_dns.x"         /* common DNS libraru defines */

#ifdef HI
#include "lhi.x"
#include "hit.x"           /* HI layer */
#include "hi.x"
#endif

#include "lqo.x"
#include "qosm.x"        /* typedefs for S1AP acceptance tests */


/*
 *
 *       Fun:    qoSmDefHdr - fill in default management header
 *
 *       Desc:   
 *
 *       Ret:    ROK     - succeeded
 *               RFAILED - failed
 *
 *       Notes:  None
 *
         File:   qosm_utl.c
 *
 */

#ifdef ANSI
PUBLIC Void qoSmDefHdr
(
Header *hdr,
Ent    ent,
Elmnt  elem,
Selector sel
)
#else
PUBLIC Void qoSmDefHdr(hdr, ent, elem, sel)
Header *hdr;
Ent    ent;
Elmnt  elem;
Selector sel;
#endif /* ANSI */
{
   TRC2(qoSmDefHdr)

   hdr->transId             = (TranId)QOSM_TRANSID;
   hdr->entId.ent           = ent;
   hdr->entId.inst          = 0;
   hdr->elmId.elmnt         = elem;
   hdr->response.selector   = (Selector)sel;
   hdr->response.prior      = (Prior)QOSM_MSGPRIOR;
   hdr->response.route      = (Route)RTESPEC;
   hdr->response.mem.region = (Region)qoSmCb.init.region;
   hdr->response.mem.pool   = (Pool)qoSmCb.init.pool;
   RETVOID;
} /* end of qoSmDefHdr() */


/**********************************************************************

         End of file:     qosm_utl.c@@/main/1 - Thu Jul  8 21:22:23 2010

**********************************************************************/

/**********************************************************************
        Revision History:

**********************************************************************/
/********************************************************************90**

     ver       pat    init                  description
------------ -------- ---- ----------------------------------------------
/main/1      -          sp                 1.LTE-CNE:SGW Initial Release
*********************************************************************91*/
