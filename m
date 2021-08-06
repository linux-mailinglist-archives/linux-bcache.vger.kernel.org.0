Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9783E21C1
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Aug 2021 04:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhHFCnx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 22:43:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43954 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhHFCnx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 22:43:53 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1762gR5U022355;
        Fri, 6 Aug 2021 02:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ErfLZC+XW3YlM4EGPbxPKMczSnuaInT0wEK9Ur8Fnf4=;
 b=UKQXkVaDZ1yo7wbxMZCkesxk41edRuYSvHC++xL0wC/zISEucJ5gIgjS7Q9obd4tpoMy
 TCabYxV2LeOzzzAFWuegmw2npK3NpFg1irUxKYro2vh1q6yEnLK6GMJiW5rFngkTcD/i
 IqfZ+O3IX13au9sj1hlrqac+FIpALW7rns1nL6XVM6uHIvj+QuT63NSkaJhc3YbYup9O
 Gtydokfbn/A0/E8JPUc2m6vJKwymc+Wli2rCwhMCggFn0GXtK9HW8O/djdfd6hTexMyB
 HLsihght/sfYiWUrA5P4OPmjBftm8PbxoEqmQfkCUuJIu6aA0xj0Xkow3GYFo7IuqogU ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ErfLZC+XW3YlM4EGPbxPKMczSnuaInT0wEK9Ur8Fnf4=;
 b=Xd1mTkngtTb1C2ru/wzM3a0QFNcvR+1QZJbzqSRCFYSIp+yMBtaH31ng7v+Sif409xt5
 p/vNVDlyWtdChd4J96BMQ1Lqbfr2ReNrKulFhQDjPCvI0rS72p1eL930HP9mfFbdQOQA
 sUaAewfWy+loLbypfGytqAam7WfVLfH/oa0bSziCHqLjAl4YNU38elGvX/t/yQtKtPzw
 /lZWt1BuCoQ3BY+NVRFTdneT6lMjG7VOpE7STF0FIVaejHrs+r5U2GpefVFx94LxxGZf
 hsQzU2TKSJGjK7IRvgXzz0L1HBEfii7pDqr1EOa2HrVDhNGhU9vx9gLyFqqtUia4xb2q vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843pavj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 02:43:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1762a72e059738;
        Fri, 6 Aug 2021 02:43:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3a7r4atwy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 02:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu+2xoFwAA/Sq2zNh3kAu4f+rTQ0isc02quXtsavUJNp5ddfm46Z1JiTSsKm72mKccgNf7Y5xCB0aTtL5/wGE3mvwkSgE0BzBIQENKoThQYWRf+tNch2MFlT0ApKxB59jOI+0BV32ZCjMaqKKTg5iuu1TSiGcq8gL+tKuY/9xLaNRXChB0CIWtnOAlDrKjJpoUlklbwA1DDgKB0gByWjYYB/HyjTAUSsFM+1e4C8JzH7+BWnyEBUvDo//8YfWiymSGUqmLaBvH53gOrk5eDukevQwaWN0wcNIShnATnz9K7w8XYzawb69DWluv4MqEQbww92i8lsGj1qLQijamp0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErfLZC+XW3YlM4EGPbxPKMczSnuaInT0wEK9Ur8Fnf4=;
 b=iD93Jgr8VR9qS5wCaJUFnRpdMrNKuv0+Su1oF/rqRGKKTCAwjnJnfMJX0bwErctLLXATu0thJqSHmR7hheN6AL3h6JlkdwnjOF78jMbLueOzk1IF2thfdW2BMh4Y2R4umXWoRD/PNI/Q4/IvwewgkI0pFA/bpl0FDwevCGEJ9SfkxVOBGpXN6AA2kEXd5yWG4YzfagM5jmKqmQlvAOHSWOA1IXH1EDPcAzQbcqqBLnNjmOJXjI8eam2dgIHi6Ga3jw3FYYt+KTRYyJv2xzV8ZWM8UAZnMnbwRTA+6xGvmLH0wKKnGWEClDQgGL3bAkfIVis0n7sHtLUpTrYZMCo+SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErfLZC+XW3YlM4EGPbxPKMczSnuaInT0wEK9Ur8Fnf4=;
 b=dtv09tI+lsT5qTxFrt6ofPbOK7kbq2deFdTwXITHVx7aA689pZq4Yz+YHrEQ4RRKVv+dCR0qT6fJqaFdwuaA6W3F3Xz5B9yZM9Chz0/ZN43ntf3xoKt8AME/ybFapt7qfoV5sYctfSSOe8f40iGzbr+SeVgBGsEl/RhtH+hYTlk=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 02:43:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 02:43:10 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/15] sd: use bvec_virt
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im0jguup.fsf@ca-mkp.ca.oracle.com>
References: <20210804095634.460779-1-hch@lst.de>
        <20210804095634.460779-11-hch@lst.de>
Date:   Thu, 05 Aug 2021 22:43:08 -0400
In-Reply-To: <20210804095634.460779-11-hch@lst.de> (Christoph Hellwig's
        message of "Wed, 4 Aug 2021 11:56:29 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:254::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 02:43:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ab521f1-794f-4814-8ad9-08d95883ede2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45526C638DFF4804D59D52F08EF39@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2biKdQen9g36NLgMB9NpEFKwTBiWr2Gwfsgll439RF9lKoPvcUAIHYqG36JfPXDV2FR7URfRK1nZxA/q4S8f2R1Cq0iuf7KUpxau3cVA/vdXtma8p1xXEFxMCIDXuBPRewidBF3Rm9REYX+C7u0xAUrSaBo9JSUhMzhV+pmJxeFFBunCqY0nYVleyWtf+NvuaAbMDK336r+QFlfvki+ta6G+KnnuD7opZCTIfRFvogei78/S7ruqRPd+8n6RlYqyaEkD7QmGuyZcaP6e2f6+a2O9v6dktxKWCkHJMJF+F3tE1oYy0RauREtacck5QWyVbwgaehdhJ3AGIxCj0TVo+3rbT5MMJ3ty5sK+rJSL4Ab0I3K0WHCos+Nwav2x38kVNaAQjH6GKdNe6i9ng+sX6vYYCTp+V+FEYZTPJAdQKssoQiEJjoHWuFquslHepGEWNsbKRC8Yiv9A69gpL3/OMyHpTATLEYhSDVtD22Q7Afr/TdZFJmjK8J7qAUWgozTXaJAOJ6XA8Xd41JqIXGj5z/gySoIbCcj7AHkiNlytduCSrku7SOuz/0O6VzS8zXG8C/morxf2mbxk4e+/hbZxSzGNVKTQDeI2Yy6KHSWF2l2i98EczoI+HaSaMJWu+Nk3qQdmtlJh16WbltQKiHXUZRErStmEbgIy9bv8GzKKKYC0Tk+Ssej/muh6v/wHTW3sof8K9Wbi1Z6/kymdE13iRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(186003)(5660300002)(86362001)(7416002)(26005)(558084003)(2906002)(4326008)(8676002)(8936002)(956004)(38100700002)(38350700002)(66556008)(66476007)(66946007)(6916009)(55016002)(36916002)(52116002)(7696005)(316002)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d0IZT/r7RmhPQ3tBCdNNRIg3kRlcg/GhZwyftwygwoa8TrR+MKpsu9mJ0wzm?=
 =?us-ascii?Q?jmrB4D/QkSTeKWQto4gs8+7BePSsC5N9XppW6M1JPurDVUYlKjdWvBVEZ8O+?=
 =?us-ascii?Q?yxWwDM6XLnIjtP7uinZZWNnmHYPSV92OblVx/SVAaCo1Ql60NYYmfAnEAG46?=
 =?us-ascii?Q?cTrGRKj0s4PLIcfHLPJEYP9KpONEiH1dfN2ciCy4nafUUmIL1DxNNzL7N7oN?=
 =?us-ascii?Q?IUckk/1PgSwGorQTZI/iaxg3uerrrFmiSkTl5XPAvKFyM3uUmlFcAl2N06/B?=
 =?us-ascii?Q?WaV34m71jfzjz0WyKFC8u1WIYd511uR7qtkz/58emRw0vP5Ir0Il10RMq6AN?=
 =?us-ascii?Q?EpemLfHd5bWsKx26mkAb4+YU4F5/eeSXRt7xMqsn5XwoVcQ/YqVIoRTSMChm?=
 =?us-ascii?Q?YVeqqd+f9UjLxf9hboaZ7L4g3CXd5c6ge/T/T4h4/m9/nC3k2P5/y5uhfRs3?=
 =?us-ascii?Q?lLqv8Bd4d7h6XVrG/Dk4VZ466CUpYFycy6OeYr2q+co/0opkl+YG9NoLZ0dD?=
 =?us-ascii?Q?KY1rxRLh7l0jfoyX/maLU1V468VMwc3O7fSf8xy3PoJLHECMyio8d7zb3MwS?=
 =?us-ascii?Q?K4wFfAOxJibt8O/N4KT5yl6kxiL9HiIb8zOKf3g5Ay8evEvRLC05/RLUaXvo?=
 =?us-ascii?Q?LAUZnAFaWjX6+8VCq0YBbPSgMXYQnnJ8pSIBG7MQhDaJ5+JHV0YtGbuR0RoP?=
 =?us-ascii?Q?JEMc4MJUYQ4zpVfAg8LYBrmpYVfCesTThCc4dn46SNdXKk1Y/zHPwzzTfQnE?=
 =?us-ascii?Q?btPOrj6ue5jfGDdESAbHom840UQEUlIbYGBK8PUVndCkKKuSRcTUJfqjzesA?=
 =?us-ascii?Q?RkSnd8CO4RE/5ggCKMBku1b6+dji9bsRFn/kp2MrMg14LuWNpMZyJkg/KBm5?=
 =?us-ascii?Q?sGEq4aKxDDf7+r/LhaQPePa3n6kUcGG26t2HLKAhQrIChN9ykMDW+CQA53g3?=
 =?us-ascii?Q?fOZzGJAIWrdNQ3fsX/oNqz0uQ2XpuVvvpBthQi/l7RPEB0fUYRWr77Uceo/j?=
 =?us-ascii?Q?lsOpcE4V4k0FRYyZy27L57Ac0ujbp1TLKO5n/M6T2UFeE0oMZnrRMGIOrPL4?=
 =?us-ascii?Q?1dKwz8WyL2d7bA9YCDmROm1zfoU8aMvtMFiTZh9oxn7o5nRkd/RaIh+QE07u?=
 =?us-ascii?Q?FhJdivGDhxfyLxx6HHIUZ1rUyapGrw8MmfziJ70jCkrykkbZfSp2SsDXHsw7?=
 =?us-ascii?Q?wL3CPkKEnR4ryZHmYF958v6s0p3biSZa+xHNE1Nfy1a8mBDqhFe8+V3X/bNG?=
 =?us-ascii?Q?A35P9nCV1rh6wzry1qE9TV7AQlfqdjfHSo7xM+KL05fbY7GwbehFqoO85DVv?=
 =?us-ascii?Q?xjogAg4hxBjYzsWGGXj8gCEW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab521f1-794f-4814-8ad9-08d95883ede2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 02:43:10.5688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIMfiozE5/gZPJvbKZVOc6/XGo1J8J5fd+V8vLrjFhFTrpc8gokWrQp1/fKnPlW+D1+dpqw9M8aRwa5wBwhvk8RWG41ogL439Nry9Jgb1e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060013
X-Proofpoint-ORIG-GUID: CStb6cVLeKmOmbEMeQn944Xlc9AD_zxg
X-Proofpoint-GUID: CStb6cVLeKmOmbEMeQn944Xlc9AD_zxg
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Christoph,

> Use bvec_virt instead of open coding it.

bv_offset is set to 0 right above but I'm OK with bvec_virt() for the
sake of consistency.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
