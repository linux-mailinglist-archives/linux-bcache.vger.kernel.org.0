Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F73E21B5
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Aug 2021 04:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhHFCjo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 22:39:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64678 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235872AbhHFCjn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 22:39:43 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1762b2S2019102;
        Fri, 6 Aug 2021 02:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+Hn7l0R+GqlTcDRD2RIYaTCMXmMpsQtjBAhz/nZK4DM=;
 b=wtFhUp294h/rlc13uwv8fmMIGzKjSJuAQjTXVCRd/2RXuLxvZe9EaXi91p+WuS3nKJq3
 7PyNcTYt9LgmkCP01kRwOevfit86jRHSAfIYuhwRT0jBVpnJK+YW2LZnN+hnrE8Zh8EV
 xZGTtkdh79cIQ461Nf72Oyg1vEz7HZ+dYbyyA/p83HQnE+jkWBnrU/Ngfs4tVBvTMoP+
 OFMbuiGur41qaEyHtr4+V824cijdB1digNF905jvb7QqHP/54ZNSsPgaGcld66nquNdD
 1bQKEaV4suKyFXpBxG0D6ezBgDZFKxo+Z2sUc/yYCGu6u+wBGq9HuBqs1GA9a3GsCjEd CQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+Hn7l0R+GqlTcDRD2RIYaTCMXmMpsQtjBAhz/nZK4DM=;
 b=u+qpQHQBwYsAIT8l4V8flAGAkdzQkSgxjYJwwB4t4taHvQgn6NCibCHFfhQVSsOD5woE
 EaTZPC7HzlCLBjf1HLQqGex/gxhpSP9LbBYTnj3Bon9DG0ULmhDRzOcff4fS3PsI1bRG
 HU6R3cfv0wluGaxCGH1DlFabmGLZS8xJLyidGeWuLhmxGBX0waPWgEoiO2HM04wjNBSQ
 sjl41N1w74BIJMVSFJE6+SzzxV3rrwZl7gUgtnsE6qLEow1IUKisK1lWRnMNWNjo1KdQ
 FrCFMc3+/MTOksTGVN6YUd28lWKGDrMKoEQ9C54LteTPnqpAsihCbhPLvuf0HkBvioam KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubt0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 02:38:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1762Zfto163611;
        Fri, 6 Aug 2021 02:38:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3a4un4x46x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 02:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdkQpd3TstKvDkHsRoy8arc1SUQn3B8ALDpM9qzBdheVFq3mv/0JnH26lYHlyqYBNDsHhrVYEF8nlBsfPGwKiGe3iKJnDaGtwiblGIb17mjjZT9sWgZpS0fe/8l+6ZbDhMARXF7b73EBuBFzftBnDwuSAiIWwbzrCnNh+4uH0WJhL0XduEr7lFcPIei2ikdhswEVCQYyvDES6D9mnTmiJ9mqQ5Z2KAUNdCtQbIxvBbfRp+ERJZTpVn5h9q53Z9Xzbd3qQaso0yupIUmWqzWkNX4TSBnypURs8S/POjYuQ7zeoEQc7WWksIfSR1p2LG9O4MHAX5k1CnNcvIfn7qgfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Hn7l0R+GqlTcDRD2RIYaTCMXmMpsQtjBAhz/nZK4DM=;
 b=bbc86LiMVO0sCcKDIUKcayptQUj7oaPpG9zmZUvG4CBuXk75S1KHAWFJ3dgQaisP8O6CjBDeCDS892fwhr9typFb/jRyKC3Cj4woJE2FcgWtJXnJJ5yYbr7mhuMGvdkV8w0wJZKCMXD8d+5nhXYCyLIFAk6Wk2y127vrjx8XtKKYTN89kiUzaL14xSiC+U8bfEB0DyThWqNMiHP1VU42GIzw96R6tRXp7uWH15WCChEeMvWRj8ObMHE9rc6YB5P/fhNlh+hv8jHCXcTM1q6ZvsGE5X9sWFvTayqr30rsOHsz7JHNCNIUN2LtsZF5kr3CbnKliMGoA5rTPND+kyI8RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Hn7l0R+GqlTcDRD2RIYaTCMXmMpsQtjBAhz/nZK4DM=;
 b=rkewLLDcTYOG2oUeyFGnv5fAVTk1uttxLUP+E7z4wSZdXPfr0cO/ElV6k0RBK1R7tiAanKNQXKpW1Sp/Sr2QHciwBUVP6+9s7C9CuBhIj7pQneTPUBcMz9234yc2IfjH2QGzMyiIsE8Kl/nYtS55cGcAqjD1puKtmgK/w725cKI=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5547.namprd10.prod.outlook.com (2603:10b6:510:da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 02:38:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 02:38:55 +0000
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
Subject: Re: [PATCH 02/15] block: use bvec_virt in bio_integrity_{process,free}
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8abguw3.fsf@ca-mkp.ca.oracle.com>
References: <20210804095634.460779-1-hch@lst.de>
        <20210804095634.460779-3-hch@lst.de>
Date:   Thu, 05 Aug 2021 22:38:52 -0400
In-Reply-To: <20210804095634.460779-3-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 4 Aug 2021 11:56:21 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0056.namprd07.prod.outlook.com (2603:10b6:a03:60::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 02:38:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80656e9e-bb66-4ddb-a736-08d95883559c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5547:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5547B17EED92CA8790B9DD698EF39@PH0PR10MB5547.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHB7bGAu3dr15epxsRd41stobM9+hqxzpWqYRpa7sS2buDJSiIwPFqJ+rmInH8fAtgR3GCzwlanaol8G+VL1dw5VJwfkNyG2NLtwuUUVjYPyCk5SBgqLqzBbW33WfSDPEmgemB8HawITd44W3tybDc/BkYYfkXuPI0D6LXLGiQxkxxOdF8ZpjOI27YUNGVeFEbYrAWHQOtcm+uWcFg8S7a9VlHIiEHA6dIwNCxPwvmaATA5VUeP/nJPLMp8TRchc1g8MGE84JC7Zj4POaRgZvf+7e+kswB+o2OXDVGml+YCOzmd81QGl0zQsPek7/0YgNZtgAuIz3jN/G5pEWTnk7OjLn0TFvOkpKFnNrVwcnZ4z9ZB4koPcZ1WGSkrh6CmnxreI8hGR2DKzPaTnO2Pjn/VLDZc37UBif+EaGEAAkT4OJHT6WV9J9AK7z4+6mpFC4VJhCh0dZIEUTEguqNfrXTpF+FkiwLIuTwNz7cczkoj60BEScnEeoTw+mpWAaKK1xmNuFB8jE+FfJ6IVhgx57jdt5NfdT+l2n9UeTn80qL8jRWABlsYkMXldOisnAvMsRutMOKxbi6osnAenq/+uVJ9UHKN6cvqNsOFR66BU9HIu+cx/kzACHrmbtFQM9GT/3ih3UjsuulGUlKTMebZaK4Y8Yz31d5haz4VLQDOSRoAgR/WNY24v9s31VNLliCWD42Prrkd+Vh09jrOrpPCzOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(186003)(55016002)(8936002)(2906002)(8676002)(7696005)(52116002)(36916002)(38350700002)(38100700002)(6916009)(478600001)(956004)(54906003)(66946007)(66556008)(5660300002)(558084003)(316002)(26005)(7416002)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4nPm/WhIumX4gu8cibF/bATl3bGoQkWwNgSRqJlX1YKLZxxFs6e0jA9AU3TK?=
 =?us-ascii?Q?pihw9E8/jdO7lqg0ga4vjp7zOBQFe38Xv48G+BA0hLfZDa9Q9ygIdgrcqkXI?=
 =?us-ascii?Q?X2mYM3eG8U+rOTnaQMNh8JEjhVZrCACGzJHid/8UVwskKKb87PIwxdoEm4Yp?=
 =?us-ascii?Q?vONM2vq5+QAJILo3O1595HJm1VQkFU8JJ29MaWSq0jFohuzwg3YXstGANBcQ?=
 =?us-ascii?Q?TpztbGN577v7KiU/Pd8Ev07ihbckIbMCLik56uXFOXl/L1xbBuV1622JGf2T?=
 =?us-ascii?Q?3J4jYDr5pl54rck0qWMAfu+JUssOkruqTen2HipObtlKO12O/4SkcJAXJWph?=
 =?us-ascii?Q?ffJCXOW+huZNbBGUENbEkJLnurQPZm8in9wndf+iKfx63sR20JLsMWOBhn+5?=
 =?us-ascii?Q?ZVRrvMaWuPEIrtFpDGLy353wFP1Am6n9RG2GjfN4+8WSyBiBv+o2hsPg70/8?=
 =?us-ascii?Q?/cHk/68gmoJpw1c2RbULbg2ogOOhhLRVxtnALk169HD7ogv/hIShfgsLB5wf?=
 =?us-ascii?Q?Wn9f3nK9IIsg9mSc6hwVJr+7T3ein1s/WSI17ISzWvFStWy74joy/gQCf9w0?=
 =?us-ascii?Q?rSYEvCAeIfYhJp0u/Gsjz+ZlHkRX32l6TBFB0WHVWYFDtAqgf5auDGxuuopV?=
 =?us-ascii?Q?gwIbdj+5Csbx/g5dBCFqGlNgCW5x6RVh77qftxmDvpeQ99HzLHdOdhyx8Hnw?=
 =?us-ascii?Q?yQRELIFNBxE5ZjaeUamlL1Xx9O37924ue05FFPcUBs4vqD/R/SbTVQZSSgXs?=
 =?us-ascii?Q?yhpe8Fri54nq7loB6V02+rQmPYj+P5wHqLPfnLO/z6SivjMt7mNVQylv0AdT?=
 =?us-ascii?Q?nNPDksdBrreq1Y57a2nNs84zprKdtN2qmJyyA730JBJCS9Q2IVM9I1+YEBjt?=
 =?us-ascii?Q?qzk9+Xg7ovyYw/rUTQB9DQr13sy+tdHDiGe7y0FlMFJnyzqaaA5z9TBSg1nn?=
 =?us-ascii?Q?S5jICH2QtI9Xm4qHGAZpHu3Dcgjrr5gHQAbBis3MphlDUMcDI3rD+KfZ9uVQ?=
 =?us-ascii?Q?gQpKJunnSeDzzuxoElmS4eGWCkMz6MGiyr/4k06oVYx2zcGyOwA3CW7d2yVe?=
 =?us-ascii?Q?MESQL8SyeKQpSOROiYQzOOqKq5mmXzSOmEm4LQAP1x3c9jveIPz3scZxsrTR?=
 =?us-ascii?Q?D533r3OjBHP8d+3jU+2TsUwdLlzpKy30VL6Y6x5bBU44z2GbeeDgQlrppf4S?=
 =?us-ascii?Q?uwPJ9//ij0IqmdhipBPK3TufGN8+NHmJ3oWfMdBC2ooHAOvcO1TTO5nBFWyf?=
 =?us-ascii?Q?CybHaMUUcHr/Fqsv5B4Vknq/4q83R9uYjx3d+NoVlf7DRXw3nxYclFNBRysS?=
 =?us-ascii?Q?+hNeD7heBnOnEXJRdra9R8o8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80656e9e-bb66-4ddb-a736-08d95883559c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 02:38:55.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKZRK5ac1beLv9++eYdbfswpaE30jL+ccAoKyUjJJwTQfbB25sNrgh6s22LdmVQ1zvhYMLG2BNUjvLvOD+C5iCCmpkkTlnDy4+y40ACTIaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060013
X-Proofpoint-GUID: I9rYJCVIPTniJ20GV4L9xRYzEmBj29-q
X-Proofpoint-ORIG-GUID: I9rYJCVIPTniJ20GV4L9xRYzEmBj29-q
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Christoph,

> Use the bvec_virt helper to clean up the bio integrity processing a
> little bit.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
