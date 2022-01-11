Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2516D48A5EE
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jan 2022 03:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiAKCzf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jan 2022 21:55:35 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28366 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231590AbiAKCze (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jan 2022 21:55:34 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B03NJI026231;
        Tue, 11 Jan 2022 02:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0MTnY7A8lWe9DT/pHy7gzNFCA3VzSOdjr5VP8KMY4zU=;
 b=uvg4RU/7AvbDthqaWMi2aQfwUdYDwbRbIhWvZAMktSKKnXhIy+RFDXZ+9KMYspVYomEA
 UIZeJLdPxq9/j43kH5hKAemOzbQdYLe37nLVg1l6vFO4ATWJDuS/8LI0rrNy1bB/kLiB
 5cUpZr3AAAgoxIlL1ruIrW17BYS8N3nEheWUxcbEJ0RFwcLS24HWTeBDhNN5pdeNvKEj
 EnxGMQwG9LDVXYEn5VFfJePLJklEiWlyTGGTv41cAV/MixpgpHvyMlG+91oG9k7Ivnkq
 cnJIjnr3OfVMh+PaWLXCwLQvhzYr1aYbLZYEFF5+eoMqTznClACHbb296RZAHBGPE2iS 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtga75c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 02:55:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B2g72A096920;
        Tue, 11 Jan 2022 02:55:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 3deyqwdywv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 02:55:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnfLxSGHT/AK8OgBYhOs3qzkGJYaE4FP8J14iBnalPNIiRVQbJDQxgtkL4kpyTOE9nfx3PNGSu46DQlJCEqHrsdRZYfFPjXrgSm25iZJWZktMe9Oty1MC+BvT73PPh1crSHgAVlZ0k6btTy/eOAJw7FMqm7WXoAa5lHT5PKDN5GbATslbB17GUMmLhx98YL0OH9dYBtCjDcHlI/WL8UTec7NdKqLUBcn5SuEo/v7fiGVU9ADsJMdSmgRmOPQ62uA6tsMJOTB7j9We0SQ7oIl8WxeTRx6Idf6ZZdvYDAOxBjj+AoUB/qaj6U9eGg5keN8ey06rgysxEJGNAw4SrzTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MTnY7A8lWe9DT/pHy7gzNFCA3VzSOdjr5VP8KMY4zU=;
 b=OKbuv3+fAYX0GtFUYJXIi90vdzksEGXFS3tAt+I7E/OmCCUa1t2mHT+PoEd0oH7GD2uRZ96FsNWWaejvEFx5zwl2dJrLSeP4B0OqZZBqsPoVeqmxWh/M4vUyuQkBT6D18bkxK1bTb+gVPy49qZ8p9MytjFAa/uXcVCjMQIX+mK/QHu/de1+IiBUtp+TMkjy2L34yUpIu7eEZri+YO7C3mjrswKRbvnhJ75f320H4bE+VjwP5Ki59aCb3FexSDquHSt5GXtPCUYkGk5ZoJpXvTr/icZVMy/MD01rIPHeJNRc6EbvjAmGt/Ygv9i1jO+8LpiAwZi19pFq/eJ9F0TGFiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MTnY7A8lWe9DT/pHy7gzNFCA3VzSOdjr5VP8KMY4zU=;
 b=bOcpJ9skQEVkDNcXcA8NSbnVGJprbfSGrTxFAzdf/atWQxqkx1EbIGCqSRa/0wsY3IE3agmhQcN4bQXxYcJQ9YXQev0UWUGZAUwKVaL++P+CBqdOQvhVN4jKwnbmj5oseFIbwYTmRzzcMJdmlLQ6QFCRH8b/Vhlcnr/S7JS96KY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 02:55:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 02:55:24 +0000
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fspvq99j.fsf@ca-mkp.ca.oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
        <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
        <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net>
        <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com>
        <c9abd220-6b7f-9299-48a1-a16d64981734@ewheeler.net>
        <98aa1886-859-abb9-164f-c9eb9be38a91@ewheeler.net>
        <yq1fspvshbw.fsf@ca-mkp.ca.oracle.com>
        <611f98fc-222-8dd2-6b81-d570fb91fc@ewheeler.net>
Date:   Mon, 10 Jan 2022 21:55:21 -0500
In-Reply-To: <611f98fc-222-8dd2-6b81-d570fb91fc@ewheeler.net> (Eric Wheeler's
        message of "Mon, 10 Jan 2022 15:30:24 -0800 (PST)")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34cf42ec-0d91-4ab1-b90b-08d9d4add0b2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5514DBDC458E009998580E598E519@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+92oGTdBCh2GklUW0WyCbWToJqrZpw9hbiebbTzuvut1Zm222AmfL8xaHdOOgb36QXF30ToHYnC+HiFERKO/RFNiW3vHpRteNCn+V0RPVamtbToowSxe5HWKsdA1UbnIFg7mlRDbXRG+6mkHgLoGDmPdALmoKsbUMjBTIYcxTXWxLYfhsYKy2iDj/GzZIA3Yt0jSRxJn3EXu2AvlvkVQKZxR6v6+cjlPCEP0QMkdZERNbWryDMiB+cdcZTjqOsDn7al0kk9rE0anjtMXb3M/NpoVhAFR82b9tZ3T/Gh6YTS5ZnMl/YySp33xfkxR5PaGwgX3486Wu51dPccvO9Oy4B0pKPx6f5T+iV0rchxtdAAw+0h0BjehiMwyB3WbsnKKHzA5EwrS5Br+KYLUGyL63VN6XHPqWomcgw51usFCq8TfIodspd2hE4vZfktexxgvd+p+AjyChm1o1gP0PBROfqLacX4qqxwwlynJ3t0qbUH3f19qnqcCQ93zqJhF/Xf0KeS6VLXBtXq1xMdFdjTONvQmT3uyh392dH7TGdzXHyfSQRHG4Dh68rnGowiBZ3fYXwqFg1VwuyV+xhNo1NV5EL29DgG60Q0dukjNSj2WdLqWd2+M0p8OQPI2mwFMcHg7LbHGGZwgyvIQGmxeJtiGys/0YQC22QkHJGWViOPoORIEvCaorATm7FJrC4p3LOr4Lrbjrj1HBfQupXGwnknHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(186003)(508600001)(52116002)(36916002)(26005)(6916009)(6506007)(4744005)(8676002)(6512007)(38100700002)(38350700002)(54906003)(316002)(86362001)(8936002)(66476007)(66946007)(6486002)(66556008)(5660300002)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3arON2cnG64ibW9fFhnA8aOre0p5iEJz5V5XZwR1SeWNR1X1HLLGwbWoGdtG?=
 =?us-ascii?Q?KvX2AcFtjjfBJ+WMtBJwLcEYQcWFLKdvK3KAWIrh4KF9TLFAe+M400k12D8i?=
 =?us-ascii?Q?nMlv3SaH4hW0BjgJDDJ+UPLFrYAHqMjPkWTj8KiYAhnulKR4CeCfTs6/pby7?=
 =?us-ascii?Q?Ihs6tpkvzcp4M+q056j1/Qt9RFYWbQfeVrOxYMsrzfZRtMlNA+ERuwiyhB5f?=
 =?us-ascii?Q?yabRtxsMmWHpd9Ab6YYRoKCxAb1osKn8HXDlPR1s3E8twNAJSJk+XERx+PLz?=
 =?us-ascii?Q?5lxSQUGvB/rxZVGpgbI8rDlTwc/PhXY/0fd1VzH9p3GRFpL9uEcnRtmmLA8h?=
 =?us-ascii?Q?6V8JuC9Cu0PD/eQs+IkQWSBuoqX9Hn6I+hmrJwQo/Pt1lldoxTFe/C4MF0ER?=
 =?us-ascii?Q?WTHFQhM7yPqhRJsHC3RxvH+guumVVK0V2TR6Z8jsDT7tpRGj4dlV2mR81ErT?=
 =?us-ascii?Q?IYPnl2FumYZIvGeNCV3XH7kwc05DlmcM3LDk3nRthEPf6/tsQg0j+bxhh2cB?=
 =?us-ascii?Q?ndVS9Iz4hbDqPP7H/guXezckGhHg5r0yELxQjOi0vfJ6a37n3/ucM6ZVbnrH?=
 =?us-ascii?Q?Yv1+p4KcW0Knys2lxfb39fvgBXOVRZASLZ422ArmtDtj6UzzuPokQPZbehm2?=
 =?us-ascii?Q?QEc3oO4Mm40JSke33VxIRyVSMP4EsTged4TXFLH9A8iszArugEBOYdp6GXjA?=
 =?us-ascii?Q?cwEvblbTM8BH+/7p0EaskEkmiuzWDtEMjqlRCAFP1OEpHNcRlzMDiaP/cR8Q?=
 =?us-ascii?Q?omNfGHWWf/nur/y9gMeKTFNSsNAgShKBV41oisDNsQPdSrYMU3hQH4ofoH1x?=
 =?us-ascii?Q?2qJtIPYWPMdkPb/TBiPANP594o7d9tSHMYZAyx6NXterhfztouhcFnmSTl1v?=
 =?us-ascii?Q?gHr+U0sTZV4gOGqY69bKhUm/S1Kj9ADv8JxKfwVi803Lo/atl4S0AZq/X6sJ?=
 =?us-ascii?Q?ihUR+sdVlVmk7h/2XBeWR8JcPszgIi4wV7QKu67RIAJad8q3uC/l2/bbC6a7?=
 =?us-ascii?Q?34/+wl7n81gclVzcFTLMFNAk+FlyCaFinq2RJ+XU+4dU/pquPRCYjdJuvtln?=
 =?us-ascii?Q?SnBWy7Ns8JmkArZND/pGdUBjPJ1G1k7gsy38ymq7W6Yei4XthLDGNv//KS65?=
 =?us-ascii?Q?ygIpKGSVEYEfqdx2OHrW6a9kp+QmsoyevDe1AfNPJmx6I+DfCkpt/BDEB0Mw?=
 =?us-ascii?Q?+ei6vnsrRgSThVDKs3mCprnOIs5npUUDut6ZcLuVYXVhQfQUDyctWWfjMRdv?=
 =?us-ascii?Q?jOoA+6C3e+VJ86Emr+nTDTlHhg4mOl5m57lOmPwYviucQ607xIiXK+jNr5IL?=
 =?us-ascii?Q?QQhE8/vSDL4OXVPujIvzDms3FoqwPiGJsZnwVzg2PctPBQ+H0fBoOOv/nc2s?=
 =?us-ascii?Q?Wl/e3km1xpFGb7HJRzjsKPF7+L1GrtK3uS2EZlsvF4yqmJSk6U46H+q49tZZ?=
 =?us-ascii?Q?PcFHZ9FGhcxkdjW5bMMu0ul2BefMVcoIIUwOP9DlDAX5+j5T/8psg3qabuSr?=
 =?us-ascii?Q?BuVQyCKClfeT7UiEPvXuKrNQDRKbohGwPvy88DnncIxEY8newOy/LtebFOoK?=
 =?us-ascii?Q?aPU2ypyCmKj6rHx+nZ7WpoXFitOYBLCJSZCElJ5yMuFHTUC8I04saSb5irnb?=
 =?us-ascii?Q?rph7TZM4nmMo/0KgAzS/C6HWHmXjkSMimtyoKr2OHZAeauIzhDx71zBaFgol?=
 =?us-ascii?Q?BH3Amw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cf42ec-0d91-4ab1-b90b-08d9d4add0b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 02:55:24.8721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5u0GbPgOf1cRHrNSGR4hj2dD1ouW8fo2pDSsKrbNcWYsWOoFqN09IlTsK8FaJSDpjCECyGdnPian/DS51250VDjWi1dbHOY180BSRUUtzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110007
X-Proofpoint-GUID: 9lgJo23f1iPBbKuNpNyVpR4-BRWCE9tB
X-Proofpoint-ORIG-GUID: 9lgJo23f1iPBbKuNpNyVpR4-BRWCE9tB
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> Do you know if io_opt can be configured on scsi devices that do not
> have io_opt provided by the controller?  If so, or if it would be easy
> to add, then configuring io_opt at the scsi layer is probably a better
> option so subsystems besides bcache would benefit.

There is currently no way to do this in the SCSI sysfs interface.
However, io_opt is a queue_limits parameter. The appropriate location
for modification is blk-sysfs.c. We already allow overriding other block
device properties such as rotational, stable_writes, discards, max I/O
size, etc. I don't see any particular reason why we couldn't also permit
overriding the optimal I/O size.

-- 
Martin K. Petersen	Oracle Linux Engineering
