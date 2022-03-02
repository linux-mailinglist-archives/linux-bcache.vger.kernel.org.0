Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D82B4C9BA0
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Mar 2022 03:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiCBC7O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 21:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiCBC7N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 21:59:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1B626AFE;
        Tue,  1 Mar 2022 18:58:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222mY8Y014686;
        Wed, 2 Mar 2022 02:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=g4Ek42ZWMBhUeOuKE+TTSlxIYYZp5yjQeQuBERNXgLs=;
 b=BWCUyFHm65BAtOU6TrI0tjZnaoHJz/emHga4+LG5LBwWiWTuh9vx0CEKodsLdhs/eryq
 Z2Ic6lRniG8VFuJqxLiLKrwNU2AzQtr3+0ekaEilyrSXxoijHkBJD1EWvfWMdwS+Gbku
 aJ7mt70FeWvdv5MvbOmoLCzElNmsOgIhGGL0yJfET702Uv/WMEbxXSsBUsrS0VtBSzlF
 QkeK/itsgNfzeQ1aewoosiOX3VmD9xFcweGYi4eSC03i0LU1PAVZEhDgb+r8AZWFj246
 TjDfA4xfzgkUHXllqrSrIU9n8ZgQrZ3N+D0S6ya1ttscJLokgBB4g1Jl3SNkUi5DlFLh Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amgyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 02:57:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2222pZKW134903;
        Wed, 2 Mar 2022 02:57:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3020.oracle.com with ESMTP id 3efdnp43qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 02:57:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hs8JbqgSwM/7ZmOusT0yEBvHjRkpluq2UrraMw0FmpRIRja1zX5rmwDgx9yaRH7ZIwDF9FRZ9FWHe2GNh55Q94PruBehpM+1d5cXYuFJYbbMqzbTSaq1bOMlROSLrCAEcDtCIKraR+xXgpg3+1jx1w6M1DOU55Qo4qQO5zprRZhvdaKd7+3d8dMO+GrD5ffrMZP66cPyU31WjGmD0C4DuGeMiIfOsbX2jSXWa40YSoPNXAZV5C+Ts/jlaq5IqQkzT5EoYihSSDHrHtzrIlOz/56Yk3n5QlzO0dBLUJS+ZB3YC87dlGm6qTveN86v+5rd9OP2yv/VsBDNIMdPsIVpng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4Ek42ZWMBhUeOuKE+TTSlxIYYZp5yjQeQuBERNXgLs=;
 b=ll1dlzILjX5a9UkuyXJe5ikPynF9RdpyyvYe5Nc2dBYa3kYsHlIXOG+ANXnOO9Fww8yms0ntpjCYE0VZuwy5QO3KErkCluXmU2KwFbM1DsRcMNjCuk79PvKe0HBlvc4ryh/FtLyjwKjMAsZXzS2caXHQ5v0waW9wYfD3xbreTq6GgDeEXs2q/gHMy9fM3kFERWSMweNp1w2ZFOOo4SiDMmg1+ni+g2sJSVesMihHQFSsIZI+N+kC0HdlNI7qptJXZ5ViKbuQ5yTcSjwcpzfjSC5MxG9NJyowUYZLPwN3pAU6Q1UIpHG5+0uNPponHDtEw48Mr37+3A+MAN/WQmgOeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4Ek42ZWMBhUeOuKE+TTSlxIYYZp5yjQeQuBERNXgLs=;
 b=tcILxRQNI3/Mjoa/GuuE7zRm+/qPzW+kcEiqaJZt3CmHPJXi7NLg9MWL6Vvphbt4BnLLF+c4Gn+GJugp3WDnWBRVaEJ4Yt/DCsDP94RCyM+onNy9Y/ZZ1JKIYtFTyvm9bCVwOuXNDWOapLuwKTLl84QQvKjqIS1MA3tdYHU5ZCw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4715.namprd10.prod.outlook.com (2603:10b6:806:fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 2 Mar
 2022 02:57:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 02:57:55 +0000
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
Subject: Re: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnhd12ox.fsf@ca-mkp.ca.oracle.com>
References: <20220301084552.880256-1-hch@lst.de>
        <20220301084552.880256-4-hch@lst.de>
Date:   Tue, 01 Mar 2022 21:57:51 -0500
In-Reply-To: <20220301084552.880256-4-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 1 Mar 2022 10:45:50 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c26137fb-a0d9-437c-10d5-08d9fbf87331
X-MS-TrafficTypeDiagnostic: SA2PR10MB4715:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4715416A18396F5BAC1F0DD18E039@SA2PR10MB4715.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MiIEf7LfKyvV6M0LKyC7xM+K3b5oYps9cVm41fFwWygELSGnFbqw8Cp4Llbfw0jIBwZopo6bpZFImRFZbq+33HSsvy88gXxU3TvWv8GlDVjjJnSxFrAhIVWla3X/hJYUhno6X6YLc9dR7bFvVmiQHNeTYyTmu6vJn6BU7uRfR+5bUCVT3wjT61m3IA0u7uChIr6H+ss6LJNTdRngTmMb3F8hgW5bJU0la4yJQBcyXwiGGrO4jf0YMAGTv2XqcROWqozTzYeKH5Fm5LQ6ZkTM3liymdxde/jwW+7vHcUGbUbZmJEmkJFhN4Y9R3KExvzdz7bpwdCFvQJ7E2SxdZCeCiz7fqqA3ZiPF/G+UnipTVNYPANWM43Iy5pft2Wu1bHJuehy2o5lNrXCIA/yRX1G1iLknK0SKK+QAFbrEVLwY6S0ugGsZkQWunoRpwFqStcQ8gF8kyW++2FTjcS2lwTlfbaCR9Vctx8QZmE94X5ORY4/WUA97hbRArammixUHCsYRVUYturkvekcNv9k0zsnZcax97T1xEhLp8vKsPxG2rFnSlzfJfifRZMfIYxgLZUxWUrmfl36Iuz/0YQgSY5NQeZN8gNiqItMRF17uVU1t57H+n7tu+HPJuYdecQXqlozIxOx0II1eyQRwrk0UA1k1CF9r27o4xtMOa+NLQWNwJH9Jd5S8zwcbHGiI52RkpGKIgF5VFeo43sUsgELHmLuzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(66556008)(5660300002)(66476007)(8676002)(316002)(6916009)(66946007)(6666004)(6506007)(2906002)(6512007)(86362001)(54906003)(36916002)(52116002)(508600001)(6486002)(26005)(186003)(558084003)(4326008)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?875h7fhyQxrq4QED1uFBLMMDGKT1znnf6ly6RGjoTeW4XFTPP3sHjQGU0GzX?=
 =?us-ascii?Q?Fh/YpEqrkYmh1RQF7CdIPdXCgW232fIaRlcGgX8cbeDNnZEIs/xbMTUgr9Fl?=
 =?us-ascii?Q?1r4MXfFjMBG/L/DzfxO25Ff1ZNfh4UmG0Yxft8eI0Q8+mLeqrUxLnWT7mUp7?=
 =?us-ascii?Q?FPcMRy+e0JIRDl+nqZnxOFWaJOkjH1W71Mt6sdDt3JK3ATWATkx8mxyEPHbp?=
 =?us-ascii?Q?RSU5YH79xPTBVi0vnQCNqo7ToF96zTcfQBpmq+CX9F6Xa/O5XRaEnqa7V8A+?=
 =?us-ascii?Q?AVklpS/wk7wHBqSKWOPWfxkfzWHuayXDYJtZ+Q1rN54IRQgxIxNnj1J3Eifc?=
 =?us-ascii?Q?30H7aIKuv+IjRsgCqrk8PjWDdpG8hA5sBCR9Ps99JyvAsqHkBnHiXdt5UF6L?=
 =?us-ascii?Q?okrUA3LGNgfERjAQ43aL2KsvPwsxECfCppJJ8cZ0wdNKbEIfZ7ubv9L138st?=
 =?us-ascii?Q?Ba+g7k3bIcgzqTKNTb2bbM08olgNfmM0y4G/3+3lg+PlT0Gof/H1wZugHl5+?=
 =?us-ascii?Q?HXLApGsrZ3lFYw8s+xXrYQxUsiq+qLa0xTtJYzaPBosZU683gnJfLfba6fho?=
 =?us-ascii?Q?TFQH770GCWWxktlp8ppueWO+aea+vCjhxetpnnS5T3pJzzvMHbjkzqY09o8E?=
 =?us-ascii?Q?8dhH9RV0Wf6EfnLq4jkBcFaIHobPUQVJRWuMcKxtbC20lLaNdROY/PLP87mC?=
 =?us-ascii?Q?O7sau45BqHvfDCtKzm9JT2Og9NWMhujmbriTR1UzDY5JhAFgx9IsE1bOk6uO?=
 =?us-ascii?Q?zrPZDlSket039vIElDfmzW4TUpbSfneo/EDPP3lDw+mASoJFf0Bwyramwwad?=
 =?us-ascii?Q?6J1mYNXxA3ByV3J3IAhgTJH2SMx0U3M1McirQo6n6DVA3Fk/RSLBvPXJsTNl?=
 =?us-ascii?Q?LtPiwztAAXvm2+cNkMVH6Y7K+Bj+dgQODVagBSclrcMGhVgxmj6Y9uThe313?=
 =?us-ascii?Q?ZSvAoDImk5ENiKMK4IbK3nnkuKYJ8o/nnOUSDg8e5NoZ+kqQuHsRP0GojtBy?=
 =?us-ascii?Q?mjZf920aFIvkPBXWD3llTCMi9Bpk0x6Dk/M980CMMLjDjR48SV3vuxkZy6Rw?=
 =?us-ascii?Q?2TDIuamB3vdmHQ4Tbi0Zl2NiqZBF3ygyEAiFdO5JrIOi8AkYJ3xtFsyDBGDO?=
 =?us-ascii?Q?jrAS0aWwvfpXTUCr1hiA2EJzfwAZJtDj0H4BUmznJ6p4069AcPLky64uv/uI?=
 =?us-ascii?Q?sBnNGt5ByLd7yxfox05x1mzKB8UwMdqpP6G220pFlUOfBwshbhSizOTFip8N?=
 =?us-ascii?Q?MHtQOz7BwUQyKZ9Td6X4UTSVpsURm8kiLmhuubOQ39V2F1s7W++mKxMPpOMl?=
 =?us-ascii?Q?sxNRRV8TigxNiabpVKMzqkikeBcVIsENIHMjPTyriFwGQB5G5LGXZZOM+vK/?=
 =?us-ascii?Q?CW2/4RK7gq7E+JBb5qN37BEpGnuRIBSb9sfoZe/ZDviyrmn/FebjdOSl3j72?=
 =?us-ascii?Q?KZ2FuYwLQfMp7D9qBXY1h54aU/ajujEhHh3mdQgM45j4PFymbs2B+w26VTkr?=
 =?us-ascii?Q?bnzTX4fJC0AKPMVf7rAt29ibUcaDMwQh+J/H+3xoIOmCUD5XGqZJ3aqP7dwW?=
 =?us-ascii?Q?ot5Apwobi+R79pnwxsc4/IkadfsROFZO4YdBNQ89Hzlq8J0YKjGrDq5A+fEO?=
 =?us-ascii?Q?soTmnNSdWzDgZQlTJvDt7LJdjeGQjhYIPi6dUdH+xVI38mHjI9TTCysPo4B4?=
 =?us-ascii?Q?Uh6w4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26137fb-a0d9-437c-10d5-08d9fbf87331
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 02:57:55.3630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUXJBOrh/Xs+6jY20VhfkPwTqrGXpkrTYce3D3j8AmV8JcY7dRzHXT87DOszRMNxA34lzcwJF0Bz4IgQo02CwzexeK83JE7hOnIZJraWSAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4715
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020011
X-Proofpoint-ORIG-GUID: 8uz4cpshiBD04SVd12ec8rjv8t0GC1iY
X-Proofpoint-GUID: 8uz4cpshiBD04SVd12ec8rjv8t0GC1iY
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

> Remove pscsi_get_bio and simplify the code flow in the only caller.

Looks good to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
