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
  
     Name:     common memory allocation library 
  
     Type:     C include file
  
     Desc:     memory library routines 
 
     File:     cm_mblk.c
  
     Sid:      cm_mblk.c@@/main/5 - Mon Nov 17 15:55:40 2008
    
     Prg:      mp
 
*********************************************************************21*/


/* header include files (.h) */
#include "envopt.h"        /* environment options */
#include "envdep.h"        /* environment dependent */
#include "envind.h"        /* environment independent */
#include "gen.h"           /* general layer */
#include "ssi.h"           /* system services */
#include "cm_mblk.h"       /* Header file */

/* header/extern include files (.x) */
#include "gen.x"           /* general layer */
#include "ssi.x"           /* system services */
#include "cm_lib.x"        /* Common library */
#include "cm_mblk.x"       /* Typedef file */

PRIVATE Void cmAddMemNode ARGS((CmMemListCp *lCp,CmMemList *node)); 


/*
*
*       Fun:   cmAllocEvnt
*
*       Desc:  This function allocates the first memory chunk,
*              which contains CmMemListCp structure at the top,
*              parcels the requested event structure out of this
*              chunk and return to the user.
*
*       Ret:   ROK 
*
*       Notes: None 
*
*       File:  cm_mblk.c
*
*/
  
#ifdef ANSI
PUBLIC S16 cmAllocEvnt
(
Size            evntSize,    /* Size of the Event structure */
Size            maxBlkSize,  /* Chunk Memory size */
Mem             *sMem,       /* Static memory region and pool */
Ptr             *ptr         /* Location to place allocated event ptr */
)
#else
PUBLIC S16 cmAllocEvnt (evntSize,maxBlkSize,sMem,ptr)
Size            evntSize;   /* Size of the Event structure */
Size            maxBlkSize; /* Memory size requested */
Mem             *sMem;      /* Static Memory region and pool */
Ptr             *ptr;       /* Location to place allocated event ptr */
#endif
{

  Data          *allocPtr;  /* Allocated Memory Pointer */
  CmMemList     *node;      /* Memory Link List Node */
  CmMemListCp   *memCp;     /* memory Link list control point */
  CmMemCb       *cb;        /* Allocated Memory Control Block */

  TRC2(cmAllocEvnt)

  /* Validation check */
  if( evntSize > maxBlkSize)
     RETVALUE(RFAILED);
 
  /* Allocate memory for the first Memory Chunk */
  /* Allocated memory should be maxBlkSize + sizeof(CmMemList) */
  if (SGetSBuf(sMem->region, sMem->pool, 
               (Data **)&allocPtr, 
               (Size)(maxBlkSize + sizeof(CmMemList))) != ROK)
     RETVALUE(RFAILED);

  /* Reset the contents */
  cmMemset((U8 *)allocPtr, (U8 )0, 
           (PTR)(maxBlkSize + sizeof(CmMemList)) );

  /* The above allocated memory chunk is structured as follows 

  +-------------------+
  |  CmMemList        |
  +-------------------+   <---- Event Structure begins here
  |  CmMemListCp      |      ^
  +-------------------+      |
  |  Event data part  |      |  evntSize
  +-------------------+      |
       ....                  |
       ....                  \/ 
  +-------------------+    
  
  */

  /* Overlay CmMemList structure on top of this allocated chunk */
  node = (CmMemList *)allocPtr;
  /* cm_mblk_c_001.101: update size value */
  node->size = maxBlkSize;

  /* Get to CmMemListCp start */
  memCp = (CmMemListCp *) ((PTR)allocPtr + sizeof(CmMemList));
  
  /* Initialise memListCp */
  CM_INIT_MEMCP( memCp,maxBlkSize,sMem);

  /* Add link list node to link list */
  cmAddMemNode(memCp, node); 

  /* Get pointer to memCb inside MemListCp */
  cb = (CmMemCb *)&(memCp->memCb);

  /* Align evntSize, if necessary */
  CM_ALIGN_SIZE(evntSize);

  cb->memAllocated = (evntSize + sizeof(CmMemList) );
  cb->initPtr = (PTR)allocPtr;
  *ptr = (Ptr) ((PTR)allocPtr + sizeof(CmMemList));
  cb->runPtr = ((PTR)(*ptr) + evntSize);

  RETVALUE(ROK);

} /* End of cmAllocEvnt */


/*
*
*       Fun:   cmInitMemCp
*
*       Desc:  This function intialises Memory Link List
*              Control point  
*
*       Ret:   ROK 
*
*       Notes: None 
*
*       File:  cm_mblk.c
*
*/
  
#ifdef ANSI
PUBLIC Void cmInitMemCp
(
CmMemListCp     *memCp,     /* Memory control pointer */
Size            maxBlkSize, /* Chunk Memory size */
Mem             *sMem       /* Static memory region and pool */
)
#else
PUBLIC Void cmInitMemCp (memCp,maxBlkSize,sMem)
CmMemListCp     *memCp;     /* Memory control pointer */
Size            maxBlkSize; /* Memory size requested */
Mem             *sMem;      /* Static Memory region and pool */
#endif
{

  TRC2(cmInitMemCp)

  /* Intialise Memory Control Point */
  CM_INIT_MEMCP(memCp,maxBlkSize,sMem);

  RETVOID;

} /* End of cmInitMemCp */ 


/*
*
*       Fun:   cmGetMem
*
*       Desc:  This function parcels memory from memory chunks 
*              It allocated big chunk as and when required
*
*       Ret:   ROK 
*
*       Notes: None 
*
*       File:  cm_mblk.c
*
*/
  
#ifdef ANSI
PUBLIC S16 cmGetMem
(
Ptr           memPtr,    /* Pointer to memCp */
Size          size,      /* Memory size requested */
Ptr           *allocPtr  /* location to place pointer */
)
#else
PUBLIC S16 cmGetMem (memPtr,size,allocPtr)
Ptr          memPtr;    /* Pointer to memCp */
Size         size;      /* Memory size requested */
Ptr          *allocPtr; /* location to place pointer */
#endif
{
 
  CmMemCb   *cb;       /* Pointer to Memory Control Block */
  CmMemList *node;     /* Memory List node */
  CmMemListCp *memCp;  /* Memory Control Point */
  /* cm_mblk_c_001.101: added local variable */
  Size       blkSize;  /* required block size */

  TRC2(cmGetMem)

  memCp = (CmMemListCp *)memPtr;
  cb = &memCp->memCb; 

  /* Make requested size aligned, if necessary */
  CM_ALIGN_SIZE(size);

  /* cm_mblk_c_001.101 : If the requested size is greater than the configured
   * max size, then allocate a new block with the requested size. This will
   * enable us to handle large allocation requests in H.323 stack for certain
   * information elements. This will not impact any normal allocation request
   * as we fall back to the configured size */
   if( size > cb->maxSize)
     blkSize = size;
   else
     blkSize = cb->maxSize;
 
  if( cb->initPtr)
  { 
    /* if a chunk is already there */
    if( (cb->memAllocated + size) <= 
           (U32)(cb->maxSize + sizeof(CmMemList)) )
    {
      /* Requested memory is available in present chunk */
      *allocPtr = (Ptr) cb->runPtr;
      cb->memAllocated += size;
      cb->runPtr += size;
      RETVALUE(ROK);
    }
  }
  
  /* For all other cases, We need to allocate a new memory chunk */
  /* Allocate buffer */
  /* cm_mblk_c_001.101: use blkSize instead of cb->maxSize */
  if (SGetSBuf(cb->sMem.region, cb->sMem.pool, 
              (Data **)&(cb->initPtr),
              (Size)(blkSize + sizeof(CmMemList)) )  != ROK)
     RETVALUE(RFAILED);

  /* Reset the contents */
  /* Initialise above allocated structure */
  /* cm_mblk_c_001.101: use blkSize instead of cb->maxSize */
  cmMemset((U8 *)cb->initPtr, (U8 )0, 
           (PTR)(blkSize + sizeof(CmMemList) ));

  /* The above allocated memory chunk is structured as follows 

  +-------------------+
  |  CmMemList        |
  +-------------------+
      Data Portion
       ....
       ....
  +-------------------+    */

  /* Overlay CmMemList structure on top of this allocated chunk */
  node = (CmMemList *)cb->initPtr;
  /* cm_mblk_c_001.101: update size */
  node->size = blkSize;

  /* Add link list node to link list */
  cmAddMemNode(memCp, node); 

  cb->memAllocated = (size + sizeof(CmMemList) );
  *allocPtr = (Ptr) ((PTR)cb->initPtr + sizeof(CmMemList));
  cb->runPtr = ((PTR)(*allocPtr) + size);

  RETVALUE(ROK);   

} /* End of cmGetMem */



/*
*
*       Fun:   cmFreeMem
*
*       Desc:  This function frees memory chunks after
*              traversing link list
*
*       Ret:   ROK 
*
*       Notes: None 
*
*       File:  cm_mblk.c
*
*/
  
#ifdef ANSI
PUBLIC Void cmFreeMem
(
Ptr    memPtr      /* Link List CP */
)
#else
PUBLIC Void cmFreeMem (memPtr)
Ptr    memPtr;     /* Link List CP */
#endif
{
  Mem         sMem;      /* Static Memory region and pool */
  U32         count;     /* Count of linked blocks */ 
  /* cm_mblk_c_001.101: removed local variable maxSize */
  CmMemList   *node;     /* Pointer to link list node */
  CmMemList   *prevNode; /* Pointer to previous node */
  CmMemListCp *lcp;      /* Memory Link List */

  TRC2(cmFreeMem)

  lcp = (CmMemListCp *)memPtr;

  sMem.region = lcp->memCb.sMem.region;
  sMem.pool   = lcp->memCb.sMem.pool;
  count       = lcp->count; 
  /* cm_mblk_c_001.101: removed getting maxSize value */

  /* Free Memory by traversing Back to Front */
  node = lcp->last;

  /* Initialise memCp running variables */
  /* User may want to reuse same memCp for further */
  /* allocations, if memCp was not a part of */
  /* event structure */
  CM_INIT_MEMCPVAR(lcp);

  while(count)
  {
    prevNode = node->prev;
    
    /* Release complete memory for present chunk */
    /* cm_mblk_c_001.101: use node->size instead of maxSize */
    if( node )
       SPutSBuf(sMem.region,sMem.pool, 
                (Data *)node, (node->size + sizeof(CmMemList)));

    node = prevNode;
    count--;
  }

  RETVOID;   

} /* End of cmFreeMem */


/*
*
*       Fun:   cmAddMemNode
*
*       Desc:  adds node to Memory linked list after last.
*
*       Ret:   ROK   - ok
*
*       Notes: None
*
*       File:  cm_mblk.c
*
*/
#ifdef ANSI
PRIVATE Void cmAddMemNode
(
CmMemListCp *lCp,               /* list control point */
CmMemList   *node               /* node to be added */
)
#else 
PRIVATE Void cmAddMemNode (lCp, node)
CmMemListCp *lCp;               /* list control point */
CmMemList   *node;              /* node to be added */
#endif
{
   TRC3(cmAddMemNode);

   lCp->count++;

   node->prev = lCp->last;
   node->next = NULLP;
   lCp->last = node;
   
   if (!node->prev)
   {
      lCp->first = node;
      RETVOID;
   }
   
   node->prev->next = node;
   RETVOID;

} /* end of cmAddMemNode */



/*
*
*       Fun:   cmGetMemStatus
*
*       Desc:  This function returns the static memory status with
*              parameters such as memory  region and pool etc
*
*       Ret:   ROK 
*
*       Notes: None 
*
*       File:  cm_mblk.c
*
*/
  
#ifdef ANSI
PUBLIC Void cmGetMemStatus
(
Ptr             memPtr,    /* Memory control pointer */
CmMemStatus     *status    /* memory region,pool and status */
)
#else
PUBLIC Void cmGetMemStatus (memPtr,status)
Ptr             memPtr;   /* Memory control pointer */
CmMemStatus     *status;  /* memory region,pool and status */
#endif
{

  CmMemListCp *memCp;    /* Memory Link List */

  TRC3(cmGetMemStatus)

  memCp = (CmMemListCp *)memPtr;

  /* Copy relevant parameters */
  status->sMem.region  = memCp->memCb.sMem.region;
  status->sMem.pool    = memCp->memCb.sMem.pool;
  status->memBlkCnt    = memCp->count;
  status->maxBlkSize   = memCp->memCb.maxSize;
  status->memAllocated = memCp->memCb.memAllocated;

  RETVOID;

} /* End of cmGetMemStatus */ 

 
/********************************************************************30**
  
         End of file:     cm_mblk.c@@/main/5 - Mon Nov 17 15:55:40 2008
  
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

*********************************************************************81*/

/********************************************************************90**
 
     ver       pat    init                  description
------------ -------- ---- ----------------------------------------------
1.1          ---      mp   1. initial release.
/main/3      ---      wh   1. When allocating memory, if the requested size
                              is greater than the configured max size, then
                              allocate a new block with the requested size. 
                              This will enable us to handle large allocation
                              requests in H.323 stack for certain information
                              elements. This will not impact any normal 
                              allocation request as we fall back to the 
                              configured size.
/main/4      ---     rbabu  1. Updated copy right information
/main/5      ---      ch   1. Updated copyright SSI Multicore Support release.
*********************************************************************91*/
