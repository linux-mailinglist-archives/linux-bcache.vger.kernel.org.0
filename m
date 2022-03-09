Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12F4D2770
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Mar 2022 05:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiCIDIO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 22:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiCIDIN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 22:08:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180214CC84;
        Tue,  8 Mar 2022 19:07:14 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8wUv028053;
        Wed, 9 Mar 2022 03:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JIRzif8ElQ11YkMCVQYex0i5TpPFXhokbAn+PgJE8CQ=;
 b=chnFz2xDbGArfA2ox7fXcYIdbBtS/zW5gAYanJrKSeRllPCxWQb0h/wZnfEeUZ31MEMF
 RuritKg1MAYxykUeN+GyE+yA8ePtRWf5dXkk+fxWS2WBSKvW1ALiWD9Q0+uopdkgkMdh
 1/gxnZW/2leqZ7BujWmg/x13uCH6bKpJ2Sf5CS58qW+zpSGaqrJpd3glqIHbnQ0Sj3VT
 /I3f1n3kMjrWMmXn6z6RkgKRgSPFFUvckeruZ2KJXi36Fw7S2ueuoqKfNGhnN1GjXAhe
 1Um5z2VDJccLcuqSiL2WDkwZvP98RffAtRrmRxaR2vte6sl2gJMKLRUcQ9VpZx82Ogan NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2gtfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:06:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22935K3k167216;
        Wed, 9 Mar 2022 03:06:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3020.oracle.com with ESMTP id 3envvm467u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:06:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3oYL3S8HtIACTiwk34rkz5hFOrDXpFI7dXfQXFwNyocfuFvXstpKBEHUoxnJ8qc+t4BhG3Qw80F7EX3PyDul7S3w3hgK7rk1EAq0a+gX2Sais0/ZS7ZhJfrYr/a/ZkR/Yo3FOK60jZB6mil/VAzFWcf7KAE8eLVVFnSJHujohlw2RG9PzJJ2ZJJV0xfX5v1RnGNpr7zq9VrtmgkwZdJ+9WIH7lDApBnoAXIyNaEMbmhu/ALVOecE0mWKFvn7YEbrwzx8kn+C0rr7hFqORO1/LKryHXoLOT/FsJurPypTaMTleLbmhoP8nVMEVo0muBBA+N56iNoSMqVpTQlkq3K9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIRzif8ElQ11YkMCVQYex0i5TpPFXhokbAn+PgJE8CQ=;
 b=I7kTael1+w8I82BxrhqQwmPmNalnO3Q/RgL/9sX4iXlwiI3dOGrKZoEJKz8wXRfkTnLz5brakqLVGfI6NylQh99m8BjjYqTkxIrvVpWcRmmpMg3PglSUjNF5wETUDUHucCHZE6f/VRCUFVO6TRzM0r41jFHNgJoBrYc16UJVbvBMBR4aP0yjNsPUCMfrp41/5FTcs8AzfHEZv+zOFSTR43OSiG60GV9NaJ5EEtDOvmPnw6C2vdlJIdVmuH5HQ51x3IVj0tQ8UdTe02KWPLbxU/mwsz9aLPAiIDOzSxys9hwQkuBo0vzGxlSX/kWe8LslSUDvNzWfkU2wSVOvOL2/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIRzif8ElQ11YkMCVQYex0i5TpPFXhokbAn+PgJE8CQ=;
 b=yOuB2qDB4rmbBPgmMnQYwUtQLbeoUsTHKuYsGGGTrIFvOKh17XeSeKQYN6ivGuwSlIWR+EVQQ0dwHh/MeAXVulmo50XQhK/NhBBqEx2b/7DOqKTS4Q+Qx39PR2YI1WqfjYVvvCvohc2h+P1iPuZ6QT49p/aLmyNbyUBN2Il83Xk=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by MWHPR10MB1854.namprd10.prod.outlook.com (2603:10b6:300:10b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 03:06:55 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:06:54 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmmvltea.fsf@ca-mkp.ca.oracle.com>
References: <20220308061551.737853-1-hch@lst.de>
        <20220308061551.737853-5-hch@lst.de>
Date:   Tue, 08 Mar 2022 22:06:52 -0500
In-Reply-To: <20220308061551.737853-5-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 8 Mar 2022 07:15:50 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd6429d1-51cd-4084-7e42-08da0179dda2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1854:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1854A9FFE5272217F0EF61FC8E0A9@MWHPR10MB1854.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YyzsduugOE9lwovdee4nORz3NBkQN9+Fl/TnfzdZ8YooaoiYR2ashxDuzief7mTABmsMarRWi+EQC5YJYZ8Ia/KlI+V+aqRc3F6V01QSRI/3TXTUndpcCGkSOiQAsrtfcvcfPWz4Oqyr1EJFF+oSsOzmYhYI6o8BdEpiJlJkHLDp1gstb/3roC5lraFDGrWu7MRwZE/QacG0dhdq3+/YalBgjtj0ZCj3dkS57P9zmwlAnS/CzaYgpr1ExDWQwcmedOKHP25S5eXMLUod+QqGkKhoWvLm9GndQfJw5BcS5wDxPHR/utoefBXhVGc2McUpXaOI4ZTwQKMCciSFjDK/3swTJQ+gNeSzp29lr9S/gkstCjPs+/uk6Rx0la44ffxbAqMsga0Edo3jiDXKUoTufnaXdWxPwnEpJs3YXhI13wqLzQn3GCRoapyRhVWn4qtfBoEYOpBVUx7zo3A3PvMDaSeTmIDO6aWFqAxq52q2vTLwxD5jAzlgN5tz7yB8KJ/iih4VueJzRF7Y7zumbyD9VIRHr6WFiZta8Ted90uwXkL6AdJWCh5egQi4QQaBdhfVVBdib6nzq2N4kqoiyjODFom/sdToorz1NLD56jq1EBrIfN6LLdXiZfENi2L0jO/MoyUnGtRPqdDdQdTckG6QcvAFQCarbT6rVs2RHrXi5YjEm4d/BDkiiYahiYO2M6XkTXsETj5cgrH6rr1MJqSFTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(52116002)(6486002)(508600001)(6506007)(26005)(36916002)(186003)(38350700002)(86362001)(66476007)(8936002)(7416002)(5660300002)(4326008)(8676002)(66946007)(66556008)(2906002)(4744005)(6916009)(54906003)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cMh16E3nrKy496uc53H5fPmMCMq/eMFf/IFriDyvW90rKJ+3TJaVkrUkfKXl?=
 =?us-ascii?Q?kMA1WynXvSYyQMGB22UibieaKx/uzBzbmwQQ5qTSJknUXrySl12NgU+EHpJh?=
 =?us-ascii?Q?KGD7b6xd6L/tdSyVdZxMys5hLgeQI3JjmvZwi5ZvBQLjzzurNE0tQXKkGflK?=
 =?us-ascii?Q?VqpU2wNJ3wMWucMqvV6UIwjQ9R6Hn2pFi7jbWnLVWPH761cMbHk5eSsQ5Oqt?=
 =?us-ascii?Q?QsjZOKtvNd8MY42/i0WFbXDhjrjw+X8o0gC80nHfiB2oco7fnaO28psjkQf/?=
 =?us-ascii?Q?qMu9WVckRfdo5WYjG47askq6BuOTQIES9pyQPyv9e+7/qSqhHoJWinV6ukD3?=
 =?us-ascii?Q?AtAX2QiGgtb5iUFkbH1L5NBSI9+8H0vOfekiNzb+wrW7cGCyiehXc1RWK8WB?=
 =?us-ascii?Q?4vG0R/03TwJyQpqpuMoZHwjrL3Vvk2KQ7ZBLH1r7IPK7KN/Mrp3lO8ljrnOi?=
 =?us-ascii?Q?S54HPaL9ZTNzdzqq44CMy49ioxzy0ymDPqYCs+sHBq1KWEmaRwSNK2nqtrRh?=
 =?us-ascii?Q?sbgGR0e5Dp9THdeKkFjv68UEp6PE6yJ9Nwjl1q8xaSh8NanO9+5+y7/F7yeI?=
 =?us-ascii?Q?V0cScPCVLTmjrtHgTslBrF3V7c69nWDXTh8aYA84TBTBzVIOJlJ0u61500FH?=
 =?us-ascii?Q?a3+GJkpBkOx13ZR4RRya68+x81HlGjFWVdHGhN9Qy3csbP2w3iw7ikt0EucG?=
 =?us-ascii?Q?4QibLfriygrUj1QDT1zAc3S6tNJ/WrNxUefFPk57tRAdF7MjhaOecJU63ke/?=
 =?us-ascii?Q?vCCQwUfbDNzdRZA2vFbw7Cak6HlHdEWPLItS+ATcUJG/seT+8Ps4ifkLirIj?=
 =?us-ascii?Q?a10yR4H+MUi1qrdcJjHhzMTu2dMZ9FJNDLqdywihW8RNQEn/KxAA8URytJDf?=
 =?us-ascii?Q?Lfg/nJcg56R/zSidN4C/pjO5kKcu5nL65bCjC9kN1a/+E1YtXYGMmxnJSXTi?=
 =?us-ascii?Q?EZlyf7OmjpSdQFsRBxeii4fTPFyk1PgYlpCDZsJ5pThriquQe2MZ3W8Z1lf7?=
 =?us-ascii?Q?UWJaYiiZ8E9m7pCG8UUMLcI4ObXa2yNsa/IJ/nhTTbNz7dgLBjRSsBwaS4Li?=
 =?us-ascii?Q?X1TcfLkvFs9NMWWfGJmugW8r/DjmBmG3P44RJgwlxLsfaLLynxMySFld4/vL?=
 =?us-ascii?Q?qAklbt61DJSU4l2y+2F6xv6FOzQ/kMZGodboHrptaKzIsZ15S6oA/PH3aoo6?=
 =?us-ascii?Q?JdRGfIzLwulciSVi9bJW77ognB5aobpE9heaQuJRYczrNtMb+EL5hFA4YN/a?=
 =?us-ascii?Q?u1wCBlXyRLSKebU79y+avJgr/Dr6UzBKHx0pVto5KNYuw1XIXOLpyxwhypng?=
 =?us-ascii?Q?AwHOZ8cQxAeLiLy7q1wUGHC+D5ybJjr/eMiW0/w1EbEYDlT7xisYQQFLuXXS?=
 =?us-ascii?Q?Yv/CQxCRToOt9LH7c0MA1B3p53QkLvlXESJxnBPaZkT3vN4/EKvAJAvolgBe?=
 =?us-ascii?Q?ci4yKbBYUkIl4V2BgrblmT7/iwOiagg0Y/JXR+tM82WyDr7ui0SI/josxmKz?=
 =?us-ascii?Q?alhQqjD3UtPn/sVEjNNX9jYEt6xw+jGoSbPvsRLfsGwqWJSGR0wu4FA//Enj?=
 =?us-ascii?Q?Ko6Xm7vIwEcjrRWoWE3WbUaqRV8PpqQS26JXrNYI8mGKolwcbN4xKgvk0Pvu?=
 =?us-ascii?Q?d12devFrlma1L4r6SUETsJAWSS+sYe4zXyE8Emg1GNhcsds+3sDbUb5+QnzW?=
 =?us-ascii?Q?zORkSHPwqy2LsiSWOQANdEmJ4Fk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6429d1-51cd-4084-7e42-08da0179dda2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:06:54.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJlGskmXSJKLaAty6IjqkKDMSXkCeyTjOpF7feTVmked8r+Fq6LIDHOcSUAzr1UWW0FbEFW55Y3rvsXdLtNqRrPvFF+6+vNuOTyydoqorrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1854
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090015
X-Proofpoint-ORIG-GUID: VgWSyWj7774d-F8-GaJuGkifFUXVdhlv
X-Proofpoint-GUID: VgWSyWj7774d-F8-GaJuGkifFUXVdhlv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Christoph,

> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
>
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.

> -struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
> +struct bio *bio_kmalloc(unsigned short nr_vecs, gfp_t gfp_mask);

I understand why you did it but this parameter reversal is a bit
scary. Hopefully gfp_t will cause any mistakes to be flagged.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
