Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88705430655
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Oct 2021 04:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbhJQC4v (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 Oct 2021 22:56:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35366 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235798AbhJQC4u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 Oct 2021 22:56:50 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNRbBI014069;
        Sun, 17 Oct 2021 02:53:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F2DuFZ9tEWw4pRHLyoqBJHru4J2Eh5wEYZRxt2aKZAw=;
 b=AOcypj59y7ZyRx1awne5AcuNgMSsM9X7ZfYDKHX05RGCPTMExifBvl+70niN1vZ1v/qv
 OBYevr+rVlNAMgkLsvMR/1TSTL+XFLoTbyHbEYyfEMoh/gLpYU2+WReNnIEvrMMtQew5
 u0KZF3siX+fkAoSMsjBHgf9NwrWbn1QU0iDpoKIIz+lcmqikA691qcjGvX8RlEboqtWl
 MXGqT6s/DyCxnx1MTGbnkzkCNDLY+iRO82M60NarPrrsUO3qE5BQLau73GOzoNyDjpP4
 KWB/cwcPQ9gSyiWWPjFxwq3wFCgpSaw4soG47553+NVXyoXeZ8spXTRrv79DQvcnvNIe 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqmasrmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:53:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2pNdu067524;
        Sun, 17 Oct 2021 02:53:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3bqkuts2mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDFvxUy5Td0BOMWY2WVU+mBNO3B4l+xUxRH3H2l/oa/baci01p0Extk94woA/P+XrqGNTTTs2dDHUk4FELk5RKigdmVo2G3bmHe8CMLRHVVHgTpFIuyDyVUyseBPJe+7QliPo2mR8AIZQTkAN30xwjdxqpWw4/ZCNGk4MY0iez2uIYrjJeM2jrVOEWY9WPqWCnsvVWAU9GIiLcU0Tv5J6xVrLm4l/14WHo5M0Xao5BAvHbeMefasdSMWkWapkJCaHhXGnX/XbziarrwOjjz26WkE9NaV2W6hbsHOvCSaQO+TYHhYk2+8QqYdy2R6OeYZosVERqqCntWQ+BQrKoUiFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2DuFZ9tEWw4pRHLyoqBJHru4J2Eh5wEYZRxt2aKZAw=;
 b=dSSdyrJA5+8XoZe/i0QOzZMCImPSFpSUryId3y3UQ89qsTTRXhTs5q/srlBr5M65B9G6Od3DZUfZRUURy7I/wp8ZpSUl99aNmP7Sb6mNtvr3RsHxZ0Wp3MJCBwSiwJ4VscHuF/MuglALQAr/NPu412Sh8yQR+Uu6hHluklXPyPtleVvcSNzsvp9eK7AvFxcG9vstRuEPeKudTdDCUMPEGIEGhGLapSuKKqt5869S3YvOaSRXn4L9IBx9UZ7GJzDpYzurv90IUOQ0VjZCcR5Kh7vvvTvxSyZb7/gQKwuz9QOZEpGngorS1Z01Wtg76Ib8xB8ebk3bc3WaglvNWt815g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2DuFZ9tEWw4pRHLyoqBJHru4J2Eh5wEYZRxt2aKZAw=;
 b=kcFmucZgHqGPmog2rswUQYiywjt/6Lqn9Geee/rYgEIxxh/BaowsjVs70bXtA6gBPA5yAreAO5vsNIR9NbEKBZv/w4whTUIOrty7EwPnPaO4/2WRUXobyOMGDH1KsG/TGk/71XORW2F3do9LTROow80RttJ9vYWDKtNk7fcyCxQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:53:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:53:49 +0000
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-m68k@lists.linux-m68k.org,
        linux-um@lists.infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9] scsi/sr: add error handling support for add_disk()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ytwfjkp.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
        <20211015233028.2167651-3-mcgrof@kernel.org>
Date:   Sat, 16 Oct 2021 22:53:47 -0400
In-Reply-To: <20211015233028.2167651-3-mcgrof@kernel.org> (Luis Chamberlain's
        message of "Fri, 15 Oct 2021 16:30:21 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0010.namprd15.prod.outlook.com
 (2603:10b6:207:17::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by BL0PR1501CA0010.namprd15.prod.outlook.com (2603:10b6:207:17::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Sun, 17 Oct 2021 02:53:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0bfa92a-e7e4-442d-5367-08d99119585e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5530FB6FDCAAC407630802F68EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsfLZfZig6woBatdGRDkFbq31aXp+FtDjZ22KG0u/EGf74TEgLQMnQ8fwVXMIG53SEp7ETZvSuwAj6Y4z3UE4fEsqieMYJWnstNbAxA7sJs/hJyanmu2jHI7wOeQ5Z4QVV8sqpVUIWhGm7+rcTgmYsryKHc1VR/Q0yEhCaV8k8ywh5tcEcHZKcDWl3LB7No4mjLxVD2n8KiPwxmL8vpZXBepFfZcwtMR1jKx+2ql+62ayBGG62x64ygXgkJKrqifRtc2JZvejCkd1tO9Xih6+zjqsKRxbXhm1Vqdb6oyvlggYv2vfidCn2AoDTdSn1zDMU4Ubi613ZwVREwNR9XmPIZbxWnZ2SyZsXBSitz7lmucZ1x+tXBSabs/feg4pZfrPTG74C958OqjGGgZ31E60WtUy9uYQealKXFf4kHyDKhf0hGpTFErkptPw9qu+xDKFjRpmSuQ+K87C1u5Cd2lQTn29vOHF0m2s+QdfCQKeZf0M7dJj18L18A2uNRj8WCh+hlJuP/wa+OQw4zGN4EGH5WJTE0zvrQBvhd6VmKDIQigpBiIT8yPDGR4Pt8xqsJSgkxJsMrBpNd/8fp63mKlLeAFVkd/BMJ8On9AnU+oHdx5/0Vs8AqA+lCS3YEGrn8q0y7dEb1bs2bkJFSzvs0E0/BkK2rPqHvqLIHvYS8yfV7ROdD7MazUWzSjcluYA/eMcUVBJ67D6pP7zQvPF6u15g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(7416002)(2906002)(7406005)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(4744005)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clQft+DB/cQ8EVhShXnj7YVUmpucmfWZRpuSu8mJ//Ky+BYesLu9ourropjG?=
 =?us-ascii?Q?RxSIHIpSCvwFSWxxIxfc/qr/8l5g0udTacPwjX+VpzIsf1R8WzQ7eBycW+ej?=
 =?us-ascii?Q?cCOPkh7KuMmBeAQLiSYysQd9gihuqhcNT2Oe2d6sTeYvCFtfeyRn9IUM4XCZ?=
 =?us-ascii?Q?gVzcpsSjY/8wpIamEkl/mXP6wt7nuNUXysbb7/GgzYUjHy0NxuauQW7HkM3y?=
 =?us-ascii?Q?GOS0/XZDZxIIrFtegT3sw2J2B8IMcKN1VgW7QbZrS6qpviFiYjyTEkUSOy0R?=
 =?us-ascii?Q?lHvHxqhFUztNFXdc287j4G+KNAj2hYgT6snPDdvGiShk32Rmbt6r71l0l8Yw?=
 =?us-ascii?Q?4HeLrfdg3748lAW+Lfyz+tGEwLpzP4VWivFDzL22/EuQ7OPi+RnBVp8Hpp4f?=
 =?us-ascii?Q?WtQj2tHyaNmU7Yo+naiUAZ6+rhmpASstZPO+W92RoddrOJliHnH8Q8rBWfrD?=
 =?us-ascii?Q?i4JJ42ridVUEETgrBjFQEb5A4QhNBT61sDrH6TXuMCUfb7OUTwUwwtURIBwt?=
 =?us-ascii?Q?sBOgY9MBo74eHnw3uthYfw3pGleEnVtR4thv+dSt0vlAESnTXeU1nGaAe51b?=
 =?us-ascii?Q?Y3b71DyF54UhxaDSAnNlTuA4HBvZQeJ9/IS2zTTGO7g4JFoJCXHEUM/9NV2m?=
 =?us-ascii?Q?JBcO2nnO3X/3Ie6jOleivATjdVjFJ8isZSnMfJzAP9GQt7bMCVFGCUSe/w4e?=
 =?us-ascii?Q?oEcRBAzVdqoxXGNy81LJ2MexpvsD1LLUkW1ezkTmorpD1Ubb/DlosXUkzvJQ?=
 =?us-ascii?Q?3SGIoBCxnVYxLdOu99LLoQKFUThfOBW5xc0ja5j/Jxrssb3FEa4vijSDE6Or?=
 =?us-ascii?Q?V5El65zm0gDXc+IF551YGzb+GMUfvJ4SHmbmOr4Wp00r+7tJPPy87Hy3Srjo?=
 =?us-ascii?Q?jwey5MAJvORBenuyMcbWgYN+ETyxmya/2m9HH6h4C2JQ5fLTpnvs18Wp74UY?=
 =?us-ascii?Q?exTtgHVuZ6Ardxmh7GyoBwilEUbu0z/Ud/J8Z/oM6JDbu83O5S5DSN78eiY4?=
 =?us-ascii?Q?jEUjOcUyf4YjaLNVugBSgZndjcnoiALFYEdGRD4QQmuTjib4yi/4Jy2cvjKl?=
 =?us-ascii?Q?7fZKcDRAtlPWZoeElS9XIBwKdQaZ0UIxs+XRqi14oJFZbM5Q5VaxaHwQSL8f?=
 =?us-ascii?Q?NNA+W1GC0Sef5Fn3G5Jd8lgHUgv22kRr5Abfwhlydx8LJ1fPzec9KaVQEcr1?=
 =?us-ascii?Q?GySCSiZ2G6B63xA+TVtsxIHt0YZEjmzwXoIrEfxnnaG2AAJC+0OUqzaM7eDA?=
 =?us-ascii?Q?Yopqf1ewabImciPqNvkFp6BoUNAo7BUZoFtgVoSJkJogbFQnudNDRPlgR5oZ?=
 =?us-ascii?Q?c9rWQY6EpSoBz7Nq+6CXH8Wm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bfa92a-e7e4-442d-5367-08d99119585e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:53:49.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5OBFaaQD8apEfWdamOSQEWEVDWX+cI9u7UMWTM7JNXOFtbhYrtY0Q8jykOxQvswZFmGFguQdsrLejGQCVSIYWH//GHD/ncfle+IdRZ2dLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170019
X-Proofpoint-ORIG-GUID: I9vDwYIJ4XUL_ytw0gWdScYgWipqJs0n
X-Proofpoint-GUID: I9vDwYIJ4XUL_ytw0gWdScYgWipqJs0n
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Luis,

> We never checked for errors on add_disk() as this function returned
> void. Now that this is fixed, use the shiny new error handling.
>
> Just put the cdrom kref and have the unwinding be done by
> sr_kref_release().

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
