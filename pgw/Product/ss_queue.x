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
 
     Name:     System Services -- Queueing
 
     Type:     C include file
 
     Desc:     System Services queuing functions.
 
     File:     ss_queue.x
 
     Sid:      ss_queue.x@@/main/2 - Mon Apr  5 18:01:19 2010
 
     Prg:      bsr
  
*********************************************************************21*/


#ifndef __SSQUEUEX__
#define __SSQUEUEX__

#ifdef __cplusplus
extern "C" {
#endif


/* demand queue structure */
typedef struct ssDmndQ
{
   SsSemaId   dmndQSema;                        /* lock for queue access */
   SLockId    dmndQLock[SS_DQ_BIT_MASK_LEN];    /* lock for each byte in 
                                                 * bitmask */
   Queue      queue[SS_MAX_NUM_DQ];             /* the queues */
   U8         bitMask[SS_DQ_BIT_MASK_LEN];      /* bit mask */
} SsDmndQ;



/* functions */
EXTERN S16  ssInitDmndQ       ARGS((SsDmndQ *queue));
EXTERN S16  ssDestroyDmndQ    ARGS((SsDmndQ *queue));
EXTERN S16  ssDmndQPut        ARGS((SsDmndQ *queue, Buffer *mBuf, \
                                              Prior prior, Order order));
EXTERN S16  ssDmndQGet        ARGS((SsDmndQ *queue, Buffer **mBuf, \
                                                           Order order));
EXTERN S16  ssFndLenDmndQ     ARGS((SsDmndQ *queue, Prior prior, QLen *len));


#ifdef __cplusplus
}
#endif

#endif /* __SSQUEUEX__ */


/********************************************************************30**
  
         End of file:     ss_queue.x@@/main/2 - Mon Apr  5 18:01:19 2010
  
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
1.1          ---      bsr  1. initial release.

1.2          ---      kp   1. C++ compilable, cosmetic changes

/main/3      ---      rp   1. SSI enhancements for Multi-core architecture
                              support
*********************************************************************91*/

