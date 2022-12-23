Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A693065518E
	for <lists+linux-bcache@lfdr.de>; Fri, 23 Dec 2022 15:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiLWOrd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 23 Dec 2022 09:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLWOrb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Dec 2022 09:47:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDB5B7DE;
        Fri, 23 Dec 2022 06:47:30 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BNEEKqk003391;
        Fri, 23 Dec 2022 14:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5S33GhZHubXjfDJTVXKvkxA3NZnSC4ePBQDDWEBhk/A=;
 b=AdYHjK2zg3bhMfKf0WZZKm2wQoV4pgZBiFtyAQwqavjPBPku6zNfTp7nqiL3q4gP43dx
 b4sa0SLvaK9KXhifx537LVuRgEH84sSNdqWCEqJhfL0wT4NFGoRKh9gHLkGomP/16zeW
 +8xkz5EmcWhqAixoO3pSFD9k74I+DiR+qeuFJAxJWMjkEsF4Yn9JgyOY6b5RPPRfq1nI
 hriAjZmj7jIYKDKvJY461Tg85wHfPhdZDBl6O3lQrUm+Mvni+0AIhHv6+OPqb8EJW3E1
 7TrM7/3kjg07asJRM1iNqr+uwVupf+SrAtJn9vc/PJSt23S5q44k9r84GYbuChXsjrf1 Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tr67ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 14:47:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BNDFEuK007699;
        Fri, 23 Dec 2022 14:47:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47fnpfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 14:47:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddJMhFQA+8XXgwsUT8FX/tSO39IPN2/C4Sbm06+w4Sj6kC1hLmQ5BOKS60Fgsto4tEUDLEl6C69Zvrzi+NyiyAAUdeax9lf8lmJM+DcMoHXvupNoBbATmPHtlSkuxgl1uRRnAtJQ9nyQSvPReVgmQ0QJ7CaRbXL9SX8lccBhh/bglYQlO+F+HtngTa0DzEVUwmlDOivMV396fBSuKsl7oVe+Ezj9qToH/FnFHKG/0iMFiwL61Zf+Px0203AxpYFu4PrI5Rf/W34AyHb27JQ7uaAUq+q3wrogJkZH9WsM5npCeA4I7ciwMwZr7xOpL1ulgcfMFXaaJpSnC3f4kX2t3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5S33GhZHubXjfDJTVXKvkxA3NZnSC4ePBQDDWEBhk/A=;
 b=GwkRYXOXMcfjJbSjwWMHG0P+zge0eB3YZ/mTvTpxBPG1EhIZwtZ1FRHyjZeJKmDrm0TIqVMf9pWLHvf1rHI74nz1wJA9CTJOEl1Q7w8Mg7m+XOqDC8EpuH64gF+khncSaCgp3pATcTRirxY5tugD7vIknZnBrhlQjI1n5qCWht7y6cttWwkJX1TYBvJJe+O6Mxnq7SFYhsvkA+DXGaBeFhUJQxDt0XK22Bz3Xd+9mL7HzT3o9jaaeAkxnBerDn/CgsfJkzQJHnyyD/FT6U/Vy/BeRZTkSEjI7h5NAPIjw+zCKPniv+g1++VOcA2O3MAQKqB3kmQN2qwrighlIDy3PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S33GhZHubXjfDJTVXKvkxA3NZnSC4ePBQDDWEBhk/A=;
 b=Lyuy1ZkSRmHNoDEp03t3cCyCCKI8YmJTdtYZNLca50J6W+l3j26D6XMMkkT9qerWIGvuPPgbf9IYMWW07E6Y8zs6ycpvodpVTzcax3ZFOKbJLjgyU9upfCEzDp3qk6SiNxR9Dbcr2NIij/EjnOfYJoBC0rQwHGvDCAFNyJoE3sk=
Received: from CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6)
 by PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Fri, 23 Dec
 2022 14:47:07 +0000
Received: from CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::f79c:e911:4586:9371]) by CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::f79c:e911:4586:9371%2]) with mapi id 15.20.5944.012; Fri, 23 Dec 2022
 14:47:06 +0000
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
        "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
        "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "kch@nvidia.com" <kch@nvidia.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Shminderjit Singh <shminderjit.singh@oracle.com>
Subject: RE: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io
 ticks from ms to ns
Thread-Topic: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io
 ticks from ms to ns
Thread-Index: AQHZFPFuNnmU8fHcpkiSBSHlMBjHga54k/MAgAL7k+A=
Date:   Fri, 23 Dec 2022 14:47:06 +0000
Message-ID: <CO1PR10MB4563F566452B9D3035A82EE298E99@CO1PR10MB4563.namprd10.prod.outlook.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
 <20221221040506.1174644-2-gulam.mohamed@oracle.com>
 <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4563:EE_|PH0PR10MB5795:EE_
x-ms-office365-filtering-correlation-id: c3ebebc7-35b1-4a4d-12ec-08dae4f49030
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MR5rLI74UzT/b97umAQylBquKoEFyBi1UiaC6J9zbGLM02pWtaPIJ9Cf5Mqcz/905+qd1UL4TE0E3TmBd52oG5tUxbobvUx+YcevU1Hr9YT2jFiiBxSluO+Quzk/5R+R4aaLg2GGdqFFt8ZTNStdAF2yST5gf+3FR9Gh2HgmCBfiT8wLbl0l2iD+WFYGKRM9Lk7hor1bXZ/rzMeU3nIvtTFcdRqvlMagOWF9k97H1JdD9YoJWoTpBAI2IfukMIedx8ZcZ/IhFDLNV9JDRyLHkMmR6Q31gGq/bSfWE4A+gYRBAPZ9oquK8eDISe2lHt6Jx+drQBsXtFtgKeg0m0OvpEkrJcLNyn+J+21TCfqv2FlYPnI8rKG5nCh9ye+1i8faAe12sUVwxFT+fry6uRl3MKCEPwl2gBT6dCiWhuRsFGpnDcbvxkkOcbz6VcMhRabDDro68Hh5WCI2SEk4+/yZIcwjm7bdIfEoTR0jCuqISNq+7/R1b5yjwYMBbg7WqSctSpheCu2YOuNXY/3Kj/XwYoidMoCZVQzOZ7AVOOYJUYNDFSU71oc468K3Kthg8qitdKsT2zH6A3v+zvklVDfmZK8AW5/7cPlb/JpLHx1UMBOV7k2kTCZ6bbELhRnM7xmxEFmLI/hyJ9aqMXNjkJN9W3ktNef/dWkQIuCISuqJ7Tnb//VpAVIBB2h2z2Ls68oJ1rVi4pjHlg9eG4OB5QjG9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4563.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(316002)(38070700005)(2906002)(54906003)(6916009)(44832011)(83380400001)(478600001)(53546011)(7696005)(6506007)(86362001)(55016003)(107886003)(9686003)(71200400001)(186003)(26005)(33656002)(52536014)(8936002)(38100700002)(41300700001)(5660300002)(76116006)(122000001)(66476007)(64756008)(66946007)(66556008)(7416002)(66446008)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EW5Uo8B53+tpfuETDtluY5h7lhLKksJdv4OKn/KdEn31sEKnSHzCaOliZJ5z?=
 =?us-ascii?Q?GDaf+cxQbgbRKW0P4+YDTL2YO4RnBNBdnqqlLez54r8shU/MEfKVtJGwBhWv?=
 =?us-ascii?Q?SyZnWR1jlPNdwFpdeOs5HRii7n/eKiosLyKZMM2bGVytnkde22WjLpT7d2cw?=
 =?us-ascii?Q?IEdv3slZm/vHiB8bvcjBXFpUuuIhFmpKJiHgiIrCkW+NfIoNJOdKOdZ2DVgD?=
 =?us-ascii?Q?YqCGu7IHxNJ5zTUjtTUcFoRQrh/OwmMov/HpvECbahPuQU3poRpxauAa5uLr?=
 =?us-ascii?Q?9MDZ6neMMMo5RvpZlurNMImG3ZpMJEoxovY+w8kwtk67C/0b2AeP140R8t2n?=
 =?us-ascii?Q?ibvO54TRLnqD55Ih1GAZykwvQb23/XoA6t68PbOVfitUuGDFq1Gp58Wsmwjq?=
 =?us-ascii?Q?uC2ZIf1BC76uKWyqJvZoe7O0Yj2CMHJcDmwOhfhTO79GNT00uPda9or5Bxan?=
 =?us-ascii?Q?enTyCcUzfUwUC13/xkS6t2P44RD2snGV4+YKwgLVjA/DaubEgQq348/F8Jm6?=
 =?us-ascii?Q?N73OyYcKD9mEt/FGJRmgmrp3mGylN78FY6obG1/NE5FZOkdkJLubeMQkv4pF?=
 =?us-ascii?Q?+z+K6Q52TfEvRzP5fO4K2m2uOTz/jrplV7t0PlOqpt/CRU+EpN382XiqpBT9?=
 =?us-ascii?Q?Xl0lOSPqGzMQL2U+9XPBeUi7fcHh00szN4UcOfHbxCxhYGvOpMxPWMlFw4rh?=
 =?us-ascii?Q?zTGVh+OkffCb8UHrXxdsFQA8RsBwl2D++/KKB4V+kjJM+G6f0TPuArmIyeu+?=
 =?us-ascii?Q?pmIgQPCYwc4EANqrSo6VohlxDx0CSuj/Lxwr6wFd6G8oaNHGJkIdT7vVLRHg?=
 =?us-ascii?Q?KItKFjmgl3tekBbj/Ro3zsRrTijaFCuBcwB8tWEWugLjg6xiPZZbu34tGmvX?=
 =?us-ascii?Q?eAjtkiEk4nm8S+NbaKv0qtptfKLb9j6+ZdiOyh0UmdBV47N8ARvQF/0A3roa?=
 =?us-ascii?Q?i+tGYt6hmZ0UH8SCH26pyII4ErCmhkT1j/U4iyn8XC6FoW5mkwYo20MEtb23?=
 =?us-ascii?Q?Ld8sib2aD3Z4tKju41WAy/VYfC+lG0vtGr9mCDXCXnAyYWCyFP+Sci1Of+ji?=
 =?us-ascii?Q?T1yD43JkVIUFRQKEyaixTZnGJERAHx1PR5tGF3p+u8Oj1oGNzsjBAmmVZ0uS?=
 =?us-ascii?Q?lbR5LjBOWRQTRocZP1aVydF+18Q0RwDt/P9g45cMXZ1ehXtFUvx7PkihhJW7?=
 =?us-ascii?Q?FjW4neXn75fqG+jqZTj0PBJTEDIMD5cVar7lD/tbhwbpBoo/hX9CSFFd8A5H?=
 =?us-ascii?Q?u5REeZQmlSLavxm6LKEGaliXhWksUmN9ynJWoeYDdoJIyMcYDq3kjLHmgDR2?=
 =?us-ascii?Q?tzFKcpQpOsMk3INi58lDPD59JzUi9boGcKBxjh/QtDfWEiWUy+aaO2BA8AmM?=
 =?us-ascii?Q?i8D68HqKJx72yhM5Y9s322zflFY+IB1HC1WiPKI9e5AghTMIH6bXsmynXVON?=
 =?us-ascii?Q?smmZ7Wb9ySeWT6rJxHpb2PMZwZ/Dtg0nEMEJQVf/8yPjfxVe+KsWeUoRp4jp?=
 =?us-ascii?Q?L1LvAgEGOfzm9aKWlDXQxKj6Sep8RibMNVti6dHdV6B98eOpK6j1aEDArrrU?=
 =?us-ascii?Q?9mBmEWXmTtFF2P3oc8MeSnAYxRlwHnaMa0OwH5pY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4563.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ebebc7-35b1-4a4d-12ec-08dae4f49030
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2022 14:47:06.8413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cubjR2yZnnjMVb3TlKXHaQlyLPbKgL8H5kHLjCl0RUo9JnGqp62srFlYb2rx/fK+2WPxRg1tRJlwLOGe5WFsSWiFWSP5t3TosrIlMnA+61U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-23_06,2022-12-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212230124
X-Proofpoint-GUID: ezNCfCW5MSRLe2i75-RAc-Yvrd9fkFj-
X-Proofpoint-ORIG-GUID: ezNCfCW5MSRLe2i75-RAc-Yvrd9fkFj-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Keith,

   Thanks for reviewing this request. Can you please see my inline comments=
?

Regards,
Gulam Mohamed.

-----Original Message-----
From: Keith Busch <kbusch@kernel.org>=20
Sent: Wednesday, December 21, 2022 10:39 PM
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: linux-block@vger.kernel.org; axboe@kernel.dk; philipp.reisner@linbit.co=
m; lars.ellenberg@linbit.com; christoph.boehmwalder@linbit.com; minchan@ker=
nel.org; ngupta@vflare.org; senozhatsky@chromium.org; colyli@suse.de; kent.=
overstreet@gmail.com; agk@redhat.com; snitzer@kernel.org; dm-devel@redhat.c=
om; song@kernel.org; dan.j.williams@intel.com; vishal.l.verma@intel.com; da=
ve.jiang@intel.com; ira.weiny@intel.com; Junxiao Bi <junxiao.bi@oracle.com>=
; Martin Petersen <martin.petersen@oracle.com>; kch@nvidia.com; drbd-dev@li=
sts.linbit.com; linux-kernel@vger.kernel.org; linux-bcache@vger.kernel.org;=
 linux-raid@vger.kernel.org; nvdimm@lists.linux.dev; Konrad Wilk <konrad.wi=
lk@oracle.com>; Joe Jin <joe.jin@oracle.com>; Rajesh Sivaramasubramaniom <r=
ajesh.sivaramasubramaniom@oracle.com>; Shminderjit Singh <shminderjit.singh=
@oracle.com>
Subject: Re: [PATCH for-6.2/block V3 2/2] block: Change the granularity of =
io ticks from ms to ns

On Wed, Dec 21, 2022 at 04:05:06AM +0000, Gulam Mohamed wrote:
> +u64  blk_get_iostat_ticks(struct request_queue *q) {
> +       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() :=20
> +jiffies); } EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
> +
>  void update_io_ticks(struct block_device *part, u64 now, bool end)  {
>  	u64 stamp;
> @@ -968,20 +980,26 @@ EXPORT_SYMBOL(bdev_start_io_acct);
>  u64 bio_start_io_acct(struct bio *bio)  {
>  	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> -				  bio_op(bio), jiffies);
> +				  bio_op(bio),
> +				  blk_get_iostat_ticks(bio->bi_bdev->bd_queue));
>  }
>  EXPORT_SYMBOL_GPL(bio_start_io_acct);
> =20
>  void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
>  		      u64 start_time)
>  {
> +	u64 now;
> +	u64 duration;
> +	struct request_queue *q =3D bdev_get_queue(bdev);
>  	const int sgrp =3D op_stat_group(op);
> -	u64 now =3D READ_ONCE(jiffies);
> -	u64 duration =3D (unsigned long)now -(unsigned long) start_time;
> +	now =3D blk_get_iostat_ticks(q);;

I don't think you can rely on the blk_queue_precise_io_stat() flag in the c=
ompletion side. The user can toggle this with data in flight, which means t=
he completion may use different tick units than the start. I think you'll n=
eed to add a flag to the request in the start accounting side to know which=
 method to use for the completion.

[GULAM]: As per my understanding, this may work for a single request_queue =
implemetation. But this request based accounting, as per my understanding, =
may be an issue with the Multi-QUEUE as there is a separate queue for each =
CPU and the time-stamp being recorded for the block device is a global one.=
 Also, the issue you mentioned about the start and end accounting may updat=
e the ticks in different=20
units for the inflight IOs, may be just for a while. So, even if it works f=
or MQ, I am trying to understand how much is it feasible to do this request=
-based change for an issue which may be there for just a moment?
So, can you please correct me if I am wrong and explore more on your sugges=
tion so that I can understand properly?

> @@ -951,6 +951,7 @@ ssize_t part_stat_show(struct device *dev,
>  	struct request_queue *q =3D bdev_get_queue(bdev);
>  	struct disk_stats stat;
>  	unsigned int inflight;
> +	u64 stat_ioticks;
> =20
>  	if (queue_is_mq(q))
>  		inflight =3D blk_mq_in_flight(q, bdev); @@ -959,10 +960,13 @@ ssize_t=
=20
> part_stat_show(struct device *dev,
> =20
>  	if (inflight) {
>  		part_stat_lock();
> -		update_io_ticks(bdev, jiffies, true);
> +		update_io_ticks(bdev, blk_get_iostat_ticks(q), true);
>  		part_stat_unlock();
>  	}
>  	part_stat_read_all(bdev, &stat);
> +	stat_ioticks =3D (blk_queue_precise_io_stat(q) ?
> +				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
> +				jiffies_to_msecs(stat.io_ticks));


With the user able to change the precision at will, I think these io_ticks =
need to have a consistent unit size. Mixing jiffies and nsecs is going to c=
reate garbage stats output. Could existing io_ticks using jiffies be conver=
ted to jiffies_to_nsecs() so that you only have one unit to consider?
[GULAM]: I am not sure if this will work as we just multiply with 1000000 t=
o convert jiffies to nano-seconds.



