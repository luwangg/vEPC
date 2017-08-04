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



/************************************************************************

     Name:     S1AP Layer

     Type:     C source file

     Desc:     C Source code for global definitions

     File:     sz.x

     Sid:      sz.x@@/main/nodal_main/akaranth_feat_lpdev_branch/1 - Tue Sep 29 21:39:57 2015

     Prg:      sn

*********************************************************************21*/
#ifndef __SZX__
#define __SZX__

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* TODO LIST */
typedef U32 SzConRefNo;

typedef struct szPeerCb SzPeerCb;   /* S1AP Peer control block */
typedef struct szAssocCb SzAssocCb; /* Association control block */

typedef struct szEndpCb
{
   CmHashListCp    assocCp;         /* SU assoc Id based associations HL */
   UConnId         locSpEndpId;     /* SCTP allocated SP end point Id */
   UConnId         locSuEndpId;     /* S1AP allocated SU end point Id */
   State           epState;         /* end point state */
   SctPort         port;            /* SCTP port for this end point */
   SctNetAddrLst   srcAddrLst;      /* source address list */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif  /* YT */
}SzEndpCb; /* end of SzEndpCb */

typedef struct szSctSapCb           /* S1AP Lower SAP Control Block */
{
   State         state;             /* state of this SAP */
   SuId          suId;              /* service user SAP id */
   SpId          spId;              /* Service Provider Id */
   Pst           pst;               /* Service user post structure */
   Ent           contEnt;           /* Controlling entity */
   U32           trcMask;           /* Trace Mask */
   S32           trcLen;            /* Trace Length */
   U8            maxBndRetry;       /* Maximum nu of bind retries allowed */
   TmrCfg        tBndTmr;           /* bind timer */
   U8            retryCnt;          /* Interface retry count */
   CmTimer       timers[SZ_MAX_SCT_SAP_TMRS]; /* max simultenous timers */
   Bool          cfgDone;            /* to detect reconfig */
   SzSctSapSts   sts;                /* statistics related to lower sap */
   Bool          endpCfgDone;        /* end point configuration done? */
   SzEndpCb      endpCb;             /* end point control block */
#ifdef SZ_RUG
   Bool          remIntfValid;    /* TRUE if remote interface version is valid*/
   Ent           verContEnt;      /* Version controlling entity */
#endif /* SZ_RUG */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif  /* YT */
}SzSctSapCb;  /* end of SzSctSapCb */

typedef struct szSztSapCb           /* S1AP Upper SAP CB */
{
   SuId         suId;               /* Service User Id */
   SpId         spId;               /* Service provider Id */
   Pst          pst;                /* Service user post structure */
   State        state;              /* state of this SAP */
   CmHashListCp  suConnLst;          /* Hash list of UE logical connections 
                                        serviced by this sap */
#ifdef SZ_RUG
   Bool          remIntfValid;  /* TRUE if remote interface version is valid*/
   Ent           verContEnt;    /* Version controlling entity */
   CmIntfVer     intfVer;       /* interface version */
#endif /* SZ_RUG */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif /* YT */
}SzSztSapCb; /* end of SzSztSapCb */


struct szPeerCb             /* S1AP Peer control block */
{
   CmHashListEnt  hashEnt;          /* Peer Hashlist Entry */
   U32            peerId;
   U8             nodeType;         /* Peer node type */
#ifdef LSZV1
   Bool           skipUeSm;         /* Bypass UE state machine */
#endif /* LSZV1 */
#ifdef SZ_MME
   Bool                    isDynamCfgd;      /* To tell whether the peer is 
                                                dynamically configured */
   SctAssocIndParams       *assocParams;     /* Incoming AssocParams for 
                                                AssocInd */
#endif  /* SZ_MME */
   U32            nmbConn;          /* No of connections towards this peer */
   SzAssocCb      *assocCb;         /* pointer to assoc CB */
   State          state;            /* state of this SAP */
   Bool           delPcb;           /* flag to delete Peer Control Block */
   U32            trcMask;          /* Trace Mask */
   S32            trcLen;           /* Trace Length */
   SzSztSapCb     *sztSapCb;        /* upper szt SAP */
   SzSctSapCb     *sctSapCb;        /* lower sct SAP */
   S1apPdu        *setupReq;           /* Queued Transaction for the Peer */
   SzPeerNodeSts  peerSts;          /* Peer Statistics */
   CmHashListCp   conRefLst;        /* Linked list of connection cb based 
                                        on lclrefNo */
   CmHashListCp   conRefLstRem;     /* Linked list of connection cb based 
                                        on rmtrefNo */
   SctStrmId      comStreamId;      /* Stream Id for common procedures */ 
   U16            nextStreamId;    /* next stream to be assigned to connection*/
   S1apPdu        *resetPdu;        /* Reset PDU */
#ifdef SZTV2
   Bool           s1Abort;          /* TURE if S1 Abort is called */
#endif /* SZTV2 */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif /* YT */
}; /* end of szPeerCb */

struct szAssocCb               /* Association control block */
{
   UConnId         spAssocId;          /* SCTP assigned association Id */
   UConnId         suAssocId;          /* S1AP assigned association Id */
   State           assocState;         /* association state */
   SzPeerCb        *peer;              /* pointer to peer CB */
   SzAssocCfg      *assocCfg;          /* pointer to assoc Cfg struct */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif /* YT */ 
}; /* end of szAssocCb */

typedef struct szPeerAddrPortEntry
{
   CmNetAddr       peerAddr;        /* Net address of the peer */
   SztPort         port;            /* port of the peer */
} SzPeerAddrPortEntry;

typedef struct szPeerAddrPortCb
{
   CmHashListEnt           hashEnt;      /* Transient peerCb Hashlist Entry for
                                             dynamic peers */
   SzPeerAddrPortEntry     peerAddrPort; /* Hash list entry for Association */
   SzPeerCb               *peerCbPtr;    /* pointer to the peerCb */
} SzPeerAddrPortCb;


typedef struct szConPartyCb         /* Connection party control block */
{
   SzPeerCb      *peerCb;           /* peer identifier */
   SctStrmId      streamNo;         /* id of SCTP stream for leg to party */
   UConnId        suConnId;
   UConnId        spConnId;             
}SzConPartyCb;


typedef struct szConCb              /* Connection control block */
{
   CmHashListEnt  lclConHlEnt;      /* Connection Hashlist Entry */
   CmHashListEnt  peerConHlEnt;     /* Connection Hashlist Entry */
   CmHashListEnt  suConHlEnt;       /* Connection Hashlist Entry */
   CmHashListEnt  peerConHlEntRem;  /* LPR: Connection Hashlist Entry */
   U8             state;            /* Status of cb: available or in use */
   SzConRefNo     lclConRefNo;      /* Local connection reference number */
   SzConRefNo     rmtConRefNo;      /* Connection reference number assigned 
                                       by peer entity */
   SzConPartyCb   cd;               /* Called party */
   U8             conType;          /* Specifies incoming or outgoing 
                                       connection */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif  /* YT */
}SzConCb;


typedef struct szNodeCb          /* Connection control block */
{
   U8            nodeType;       /* Node Type: SGSN/RNC */
   SzProtCfg     protCfg;        /* protocol configuration */
   SzSctpAddr    nodeAddr;         /* Associated address */
   U8            cfgDone;        /* TRUE or FALSE */
   U16           nmbMap;         /* number of peer connected */
   /*Added for updating the S1AP control block */
#ifdef YT
  CmPFthaRsetMap szYtCb;
#endif  /* YT */
}SzNodeCb;

/* S1AP Global Control Block */
typedef struct _szCb
{
   TskInit         init;               /* Task initialization info. */
   SzGenCfg        genCfg;             /* general configuration */
   SzGenSts        genSts;             /* general statistics */
   SzGenSta        genSta;             /* General status */
   SzSztSapCb      **sztSapLst;        /* Array of pointers to upper SAPs */
   SzSctSapCb      **sctSapLst;        /* Array of pointers to lower SAPs */
   SzNodeCb        nodeCb;             /* Node configuration */
   CmHashListCp    peerLst;            /* Hash list of peer control blocks */
   CmHashListCp    peerAddrPortLst;    /* Hash list of peer addresses and port
                                          for configuring dynamic peers */
   CmTqCp          szTqCp;             /* timing queue control point */
   CmTqType        szTq[SZ_TQSIZE];    /* timing queue */

   U8              outOfRsrc;          /* out of resources */
   U8              pendingOp;          /* Reset/Reset Resource pending */
   CmHashListCp    lclConCp;           /* Hashlist of Connection cb */
   U32             lclConCntr;         /* Counter to allocate location con id */
   Bool            shutdown;           /* Layer is shutdown */
#ifdef YT
#ifdef SS_MULTIPLE_PROCS
   Void            *psfCb;              
#endif /* SS_MULTIPLE_PROCS */ 
   /*Added for updating the S1AP control block */
  CmPFthaRsetMap szYtCb;
#endif /* YT */
#ifdef SS_MULTIPLE_PROCS
   U8            used;
#endif /* SS_MULTIPLE_PROCS */
   U8             nodeDbg[SZ_DBGSIZE]; /* Node level debug information */
#ifdef SZ_RUG
   U16            nmbIntfInfo;
   ShtVerInfo     *intfInfo;
#endif /* SZ_RUG */
} SzCb; /* end of SzCb */


#ifdef SZ_RUG
typedef struct szVerCb
{
   ShtVerInfo intfInfo;
#ifdef YT
   CmPFthaRsetMap szYtCb;
#endif /* YT */
}SzVerCb;
#endif /* SZ_RUG */

#ifdef SS_MULTIPLE_PROCS
EXTERN SzCb  szCbLst[SZ_MAX_INSTANCES];
EXTERN SzCb  *szCbPtr;
#else /* SS_MULTIPLE_PROCS */
EXTERN SzCb  szCb;
#endif /* SS_MULTIPLE_PROCS */

typedef S16 (*PFRAM) ARGS((SzConCb *conCb, SzPeerCb *peerCb, S1apPdu *pdu));
typedef S16 (*PFSZLIMSGHANDLER) ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
typedef S16 (*PFSZMGMTUIMSGHANDLER) ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                          SzSztSapCb *uSapCb, U8 *cause));

/**********************************************************************
 Externs
**********************************************************************/

EXTERN U8 SzMsgId[SZT_MAX_PROC_ID][SZT_MAX_MSG_TYPE];
#ifdef SZ_MME
EXTERN PFRAM szSmUiMme[SZ_MAX_MSG_ID][SZ_MAX_ST];
EXTERN PFRAM szSmLiMme[SZ_MAX_MSG_ID][SZ_MAX_ST];

EXTERN PFSZLIMSGHANDLER szLiRcvMme[SZ_MAX_MSG_ID];
EXTERN PFSZMGMTUIMSGHANDLER szMgmtUiMme[SZ_MAX_MSG_ID];
#endif /* SZ_MME */

#ifdef SZ_ENB
EXTERN PFRAM szSmUiEnb[SZ_MAX_MSG_ID][SZ_MAX_ST];
EXTERN PFRAM szSmLiEnb[SZ_MAX_MSG_ID][SZ_MAX_ST];

EXTERN PFSZLIMSGHANDLER szLiRcvEnb[SZ_MAX_MSG_ID];
EXTERN PFSZMGMTUIMSGHANDLER szMgmtUiEnb[SZ_MAX_MSG_ID];
#endif /* SZ_ENB */

/**********************************************************************
 Function Declarations
**********************************************************************/

#ifdef SS_MULTIPLE_PROCS
EXTERN S16 szActvTmr ARGS((ProcId proc,Ent ent, Inst inst));
#else /* SS_MULTIPLE_PROCS */
EXTERN S16 szActvTmr ARGS((Void));
#endif /* SS_MULTIPLE_PROCS */
EXTERN S16 szGetSId ARGS((SystemId *s));

/* Node Database API functions */
EXTERN S16 szNdbAllocConCb ARGS((SzConCb **conCb,SzPeerCb *peer));
EXTERN S16 szNdbGetConCb ARGS((SzConRefNo conId,SzConCb **connectionCb));
EXTERN S16 szNdbDeallocConCb ARGS((SzConRefNo conRef,SzPeerCb *peerCb,
                                   U8 conRefType));
EXTERN S16 szNdbGetStream ARGS((SzPeerCb *peerCb,SctStrmId *strmId));
EXTERN S16 szNdbInitPeerLst ARGS((Void));
EXTERN S16 szNdbAllocPeerCb ARGS((U32 peerId, SzPeerCb **peer));
EXTERN S16 szNdbChkPeer ARGS((TknU32 peerId,SzPeerCb **peerCb));
EXTERN S16 szNdbRelConns ARGS((SzPeerCb *peer));
EXTERN S16 szNdbDeallocPeerCb ARGS((SzPeerCb *peer));
EXTERN S16 szNdbDeallocAllPeerCb ARGS((SpId sapId, U8 sapDir, U8 opn));
#ifdef SZ_MME
EXTERN S16 szNdbAllocDynamPeerCb ARGS((SuId suId, SzPeerCb **peer));
EXTERN S16 szNdbDeallocDynamPeerCb ARGS((SzPeerCb *peer));
#endif /* SZ_MME */
EXTERN S16 szNdbFillPeerAssocParams ARGS((SzPeerCb *peerCb,
                                          SzAssocCfg *assocCfg));
EXTERN S16 szNdbAddPeerAddrPortCb ARGS((SctNetAddrLst *dstAddrLst, 
                                         SctPort dstPort, 
                                         SzPeerCb *peerAssoc));
EXTERN S16 szNdbFindPeerAddrPortCb ARGS((SctNetAddrLst *dstAddrLst, 
                                         SctPort dstPort, 
                                         SzPeerCb **peerAssoc));
EXTERN S16 szNdbRemPeerAddrPortCb ARGS((SzPeerCb *peer));

/* State machine module interfaces */
EXTERN S16 szSmExcMt ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu,
                            U8 evnt,U8 dir));
EXTERN S16 szSmRcvEstStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                  S1apPdu *pdu));
EXTERN S16 szSmIdleStPeerErr ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                   S1apPdu *pdu));
EXTERN S16 szSmPeerErrHdlr ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu));
EXTERN S16 szSmSndConnStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                   S1apPdu *pdu));
EXTERN S16 szSmSndEstStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu));
EXTERN S16 szSmLclRlsReq ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu));
EXTERN S16 szSmLclErrMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu));
EXTERN S16 szSmLclErrState ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                  S1apPdu *pdu));
EXTERN S16 szSmSndIdleStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                   S1apPdu *pdu));
#ifdef SZ_ENB
EXTERN S16 szSmSndConnStHoFail ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                     S1apPdu *pdu));
EXTERN S16 szSmRcvConnStPathSwReqFail ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                             S1apPdu *pdu));
#endif /* SZ_ENB */

#ifdef SZ_MME
EXTERN S16 szSmSndConnStPathSwReqFail ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                              S1apPdu *pdu));
EXTERN S16 szSmRcvConnStHoFail ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                      S1apPdu *pdu));
#endif /* SZ_MME */
EXTERN S16 szSmRcvIdleStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                       S1apPdu *pdu));
EXTERN S16 szSmRcvConnStMsg ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                      S1apPdu *pdu));
EXTERN S16 szSmSemPeerErr ARGS((SzConCb *conCb,SzPeerCb *peerCb,S1apPdu *pdu));
EXTERN S16 szSmRcvIdleStErrInd ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                      S1apPdu *pdu));
EXTERN S16 szSmRcvConnStErrInd ARGS((SzConCb *conCb,SzPeerCb *peerCb,
                                           S1apPdu *pdu));

/* Database module interfaces */
EXTERN U16 szDbGetEnbS1apId ARGS((S1apPdu *pdu));
EXTERN U16 szDbGetMmeS1apId ARGS((S1apPdu *pdu));
EXTERN S16 szLiErrHndlr ARGS((S1apPdu *pdu, U8 group,U16 cause, 
                              S1apPdu **rspPdu,Mem mem));

/* Upper interface module interfaces */
EXTERN S16 szUiSndConInd ARGS((SzConCb *conCb,SztConInd *conInd));
EXTERN S16 szUiSndConCfm ARGS((SzConCb *conCb,SztConCfm *conCfm));
EXTERN S16 szUiSndDatInd ARGS((SzConCb *conCb,SztDatEvntInd *datEvt));
EXTERN S16 szUiSndUDatInd ARGS((SzPeerCb *peerCb, SztUDatEvnt *uDatEvn));
EXTERN S16 szUiSndRelInd ARGS((SzConCb *conCb,SztRelInd *relInd));
EXTERN S16 szUiSndRelCfm ARGS((SzConCb *conCb,SztRelCfm *relCfm));
#ifdef SZ_MME
EXTERN S16 szUiSndPeerAssocInd ARGS((SzPeerCb *peerCb,
                                      SztPeerAssocInd *peerAssocInd));
#endif /* SZ_MME */

EXTERN S16 szEncode ARGS((Mem *mem, S1apPdu **s1apPdu, Buffer **mBuf));
EXTERN S16 szDecode ARGS((Mem *mem, CmPAsnErr *asnErr, S1apPdu **s1apPdu,
                            Buffer **mBuf));
#ifdef SZTV1
EXTERN S16 szIeEncode ARGS((Mem *mem, SztEncDecEvnt *sztEncDecEvnt));
EXTERN S16 szIeDecode ARGS((Mem *mem, CmPAsnErr *asnErr,
                             SztEncDecEvnt *sztEncDecEvnt));
#endif /* SZTV1 */
EXTERN S16 szGetIE  ARGS((SztS1AP_PDU *pdu, U32 id, TknU8 **ie));
/* sz008.301: Kwork fix */
EXTERN S16 szDbFillResetAck ARGS((S1apPdu *pdu, S1apPdu **rstAckPdu, Mem mem, U8 *cause));
EXTERN S16 szDbFillResetFrmPdu ARGS ((S1apPdu *pdu, S1apPdu **rstPdu, Mem mem));

EXTERN S16 szUtilsGetConCb ARGS((SzPeerCb *peerCb, S1apPdu  *pdu, SzConCb
         **conCb));
EXTERN S16 szUtilsBldUnsucOutComeMsg ARGS((S1apPdu  *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errPdu, Mem mem, CmPAsnErr *asnErr));

EXTERN S16 szDbFillMMEConfigUpdFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));
EXTERN S16 szDbFillENBConfigUpdFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));
EXTERN S16 szDbFillS1SetupFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));
EXTERN S16 szDbFillPathSwRqstFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));
EXTERN S16 szDbFillHovrFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));
EXTERN S16 szDbFillHovrPrepFail ARGS((S1apPdu *pdu, U8  causeChoice, U32
         causeVal, S1apPdu **errIndPdu, Mem mem, CmPAsnErr *asnErr));

/* Utility funtions */
EXTERN S16 szUtilsGetMsgIdx ARGS((U8 *evnt,S1apPdu *pdu));
EXTERN S16 szValidateSdus ARGS((S1apPdu *pdu,U8 primType, U8 *evnt));
EXTERN S16 szUtilsAllocConId ARGS((U32 *connId));
EXTERN S16 szDbFillInitCxtSetupFail ARGS((S1apPdu *pdu,
                                          U8  causeChoice,
                                          U32 causeVal,
                                          S1apPdu **initCxtSetupFail,
                                          Mem mem,
                                          CmPAsnErr *asnErr));
EXTERN S16 szDbFillUeCxtModFail ARGS((S1apPdu *pdu,
                                      U8  causeChoice,
                                      U32 causeVal,
                                      S1apPdu **ueCxtModFailPdu,
                                      Mem mem,
                                      CmPAsnErr *asnErr));
EXTERN S16 szDbFillErrInd ARGS((S1apPdu *pdu,
                                U8  causeChoice,
                                U32 causeVal,
                                S1apPdu **errIndPdu,
                                Mem mem,
                                CmPAsnErr *asnErr));
EXTERN S16 szIncErrSts ARGS((SzPeerCb *peer, U16 causeTyp, U16 cause));

/* Management module interfaces */
EXTERN S16 szUbndSztSap ARGS((SpId uSapId, U8 opn));

#ifdef SZ_ENB
EXTERN S16 szMgmtUiSetupReq     ARGS((SzPeerCb *peerCb, S1apPdu *pdu, 
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtLiPaging       ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiSetupRsp     ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiSetupFailure ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiOvldStart    ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiOvldStop     ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiWarningReq   ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiMmeDirTrans  ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
#endif /* SZ_ENB */

#ifdef SZ_MME
EXTERN S16 szMgmtUiSetupRsp     ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtUiSetupFailure ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtLiSetupReq     ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiWarningRsp   ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiEnbDirTrans  ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
#endif /* SZ_MME */

EXTERN S16 szMgmtUiInvldMsgHandler ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtUiMsgHandler   ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtUiRst          ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtUiRstAck       ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtLiRst          ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiRstAck       ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtUiErrInd       ARGS((SzPeerCb *peerCb, S1apPdu *pdu,
                                      SzSztSapCb *uSapCb, U8 *cause));
EXTERN S16 szMgmtLiErrInd       ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szMgmtLiMsgHandler   ARGS((SzPeerCb *peerCb, S1apPdu *pdu));

EXTERN Void szSendLmAlarm ARGS((U16 category,U16 event,U16 cause,
                                 SzUstaDgn *dgn));
EXTERN S16 szSendLmTrc    ARGS((S32 trcLen, SzTrc *trcParam, Buffer *mBuf));
EXTERN S16 szShutdown     ARGS((Void));

/* Lower interface module interfaces */
EXTERN S16 szLiSndToLower   ARGS((SzPeerCb *peerCb, SzConCb *conCb,
                                   S1apPdu *pdu));
EXTERN S16 szLiRcvFromLower ARGS((Buffer *mBuf,SzPeerCb *peerCb));
EXTERN S16 szLiCOMsgHandler ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szLiPeerErrHandler ARGS((SzPeerCb *peerCb, S1apPdu *pdu));
EXTERN S16 szLiSndAssocReq  ARGS((SzAssocCb  *assocCb));
EXTERN S16 szLiTermAssoc    ARGS((SzPeerCb  **peerCb, Bool assocAbort));
#ifdef SZ_MME
EXTERN S16 szLiDynamPeerConfig ARGS((SuId suId,
                                      SctAssocIndParams *assocParams));
#endif  /* SZ_MME */

/* Timer module interfaces */
EXTERN Void szTmrEvnt ARGS((PTR cb, S16 event));
EXTERN S16 szRegInitTmr ARGS((Void));
EXTERN Void szStartTmr ARGS((CmTimer *tmr,PTR cb,U8 evnt,TmrCfg *wait));
EXTERN Void szStopTmr ARGS((CmTimer *tmr));

EXTERN S16 szDelSztSap ARGS(( SpId sapId, U8 opn));

EXTERN S16 szDelSctSap ARGS((SuId lSapId, U8 opn));
#ifdef SZ_RUG
EXTERN S16 szSetVer ARGS((ShtVerInfo *shtVerInfo, CmStatus   *status));
#endif /* SZ_RUG */
EXTERN S16 SPrntS1ApMsg( Buffer *mBuf, U8  dir);
#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* __SZX__ */

/**********************************************************************
 
         End of file:     sz.x@@/main/nodal_main/akaranth_feat_lpdev_branch/1 - Tue Sep 29 21:39:57 2015
 
**********************************************************************/

/********************************************************************40**
 
        Notes:
 
*********************************************************************41*/

/********************************************************************50**
 
*********************************************************************51*/

/********************************************************************60**
 
        Revision history:
 
*********************************************************************61*/

/********************************************************************80**
 
*********************************************************************81*/
/********************************************************************90**
 
   ver      pat    init                  description
--------- -------- ----- ----------------------------------------------
/main/5      ---      va           1. Updated for S1AP release 4.1
*********************************************************************91*/
