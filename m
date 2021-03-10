Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2403346BB
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Mar 2021 19:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhCJS3X (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Mar 2021 13:29:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36598 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhCJS3M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Mar 2021 13:29:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AIEk2I015412;
        Wed, 10 Mar 2021 18:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=phYaTADnsArsxeED7694g+AgeLzfJshSdz79W67BHUw=;
 b=osY7Wys0EYtALiZjzmRAdVS1QEjbgP820sJ03KUXw0r+QFrjafj6ThB8lLpxRih8zYVh
 4ivQWNosBNZZqPpeyy39BqL+6QR9ttn+7k6e2fNyGTIVwXMSBBzpzmFqliEGzGUI1qcR
 zh7z6xoSeXlyPQky1mQGShZmmuuYJHKOI6V7TG3eHl1S3Is/SCqWw+07kVtgURhM1GpP
 ymEinINTwL4cCbsXbHCWkexfsNmLWrCaR3Ah0N1jlCVCPyH/KuwGk7l8gPjQE9bTACcb
 fOTXEximhHXyKUJrBnF+pAl4REhmfpm8IOQ0LH72hFM6Y7edKe6VjxEsu3BwSJmFHIDf Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3741pmm00y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 18:28:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AIFXKQ007845;
        Wed, 10 Mar 2021 18:28:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 374kn1bs7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 18:28:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4EFvDulXjCOZTIgkCenKowqG5EI64B8cC6c1sTJ9oF3i+8w/uyM2OHDfBPhDsjHY7erq1sFhI83r7zwbhDkgfWIK51kEdwCO9O42q5PnZkP1pXrnFUHupF53yufN0V3Y6TQ1XCyHuwKKPzzQsUgIlpYDtwrWZcRHlNoYKR6aOgLwWzdcETzyn/ihy5DrK1d8Qt4JPrpzgUrzU0p56UKr5fI7QEvaiZFwc8cfat94IHjKSe+Zjl8At+jyy3RkEVCTvumvlHHkhvqZDqXEDG0u7dDTFrF5bNvHVYiXkEnY65UdMts31Wj77LhdLJVKeiQwxUt5ntTrgCznbXRNjSqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phYaTADnsArsxeED7694g+AgeLzfJshSdz79W67BHUw=;
 b=Q3+PSQbMccEQxfrrLrEK2SkZ0Ye2prYtqXG1dWfKpz5eNAe0HqEr1la6RkoT2r1GNAsWUcdTzklUbdGGuVYabg9f4SK/tOHLsMZHu+Sr0ew6ZZQL/Fa67YOr+9qZeghxchW7H5JSVJ2PFz5HFa7ipLIevSNKK0x2pKAbJEIEXSy6jim5g9SHVZPbhKvtBFLjd2f2+eDUr73cZGQUSxt+U8MtTuT8iamCfygZp7E8bj2qgfr5cC/rqpmXgOTQsf8YtE+xC1PQaC9muR3vuRl4dkd5x6tRnigEVj6P8QhBQwqEVVhuJmfswwUqQ7q/hRhhK36pOB7zPBV57Iq/gEd/XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phYaTADnsArsxeED7694g+AgeLzfJshSdz79W67BHUw=;
 b=jknUGUKhX3hG6ntEbdeS/F0SeLOSkyhyvHc2lXEe/05KOeZR0J7gqS6pDSEGW1DzhsmX6nGkuQa21C5ULnixrdg5e1SQ3l+EmPjWEJufsOm9Q3v7QcG6AIBV29FEnoBMEZc/kjM38gj69WSxFgFHZhHMDUtzSBpFBP57orQVLMA=
Received: from CY4PR1001MB2357.namprd10.prod.outlook.com
 (2603:10b6:910:42::14) by CY4PR1001MB2261.namprd10.prod.outlook.com
 (2603:10b6:910:41::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 10 Mar
 2021 18:28:41 +0000
Received: from CY4PR1001MB2357.namprd10.prod.outlook.com
 ([fe80::2419:5987:3a8f:f376]) by CY4PR1001MB2357.namprd10.prod.outlook.com
 ([fe80::2419:5987:3a8f:f376%6]) with mapi id 15.20.3890.040; Wed, 10 Mar 2021
 18:28:41 +0000
From:   William Kucharski <william.kucharski@oracle.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
Thread-Topic: [PATCH v2] include: Remove pagemap.h from blkdev.h
Thread-Index: AQHXFR6V9lQ5KyJS8UGx0ZyPgBlEuap9jCUA
Date:   Wed, 10 Mar 2021 18:28:41 +0000
Message-ID: <1776D861-AEC7-417E-89E2-24F1FBFEB30D@oracle.com>
References: <20210309195747.283796-1-willy@infradead.org>
In-Reply-To: <20210309195747.283796-1-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [2601:285:8200:4089:486a:88fe:ca01:b371]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7463f76e-7da1-42e6-a622-08d8e3f2548b
x-ms-traffictypediagnostic: CY4PR1001MB2261:
x-microsoft-antispam-prvs: <CY4PR1001MB2261D5B7D6231964ED7A17FE81919@CY4PR1001MB2261.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u//niyytfvdcSc8ncQ+tJTG20dYwISm/Xe5A4hclXHHMCVZS4mX9ArMsTVqsUiAKxL06DXis6I1SDB/Ao7g473oLP12P12LF8OXtNCij22rTq3GzimFdfbmiJJ1DcpkkYW4skqPioNaVJTvZ6OJ0FGR7akMd4oATI/3l/xHfHiDvSGTZjDQGpGNObCJxsQeqnlmnSdLDGjRnRjQ5FR2sphnKfhO/tZZfJNazZZNzNqhs6DUXNrs6FZLHbeXzeQKQj2mDBmieptp01s0Go52fLYktWItApqkw4c8350yNtyHE0Nhx3sxf0RVa11YMvHpt3VgPk/V0i8Gdp32ZUzQtPrDGnzv4CqmmFo6zQVgkGu/G8wH/AQeE8grvS0L8SBL1GR2flwzyqxsONUmCrf+oDmvTvl+kRz7v7q7iRx40Mh4olNSNaet2HJIEtogtvYD4EJXy54x107LtvgE6fa9iCUHkmz+xuUBBKyiDIQnK+W9fG9cdLP0pwtMdY/qi8FMwo3aHEZWzGSaOkmVxlZzsHzLh0upsZa4VLsBjU6wyRSeJf1bwHNfdeoH5IPRsHXJ+ehYe/KFXvxzcdte0U2EjFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2357.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(83380400001)(66476007)(6916009)(5660300002)(71200400001)(8676002)(6512007)(66946007)(2906002)(76116006)(33656002)(6506007)(53546011)(316002)(86362001)(36756003)(64756008)(4326008)(66446008)(66556008)(8936002)(6486002)(2616005)(54906003)(44832011)(478600001)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?w77EzarjfwLzfxAmHiZ2nFXALp8SK1k7Hn+Y0yRNU+vzFXrihFzXgi8NSrPu?=
 =?us-ascii?Q?pfflOoBxzqImngu1d1RTCUXWVcG93mTANMOwi5WRPae9YT+FQ3p6Ibqd4T7f?=
 =?us-ascii?Q?O883s8Z2eXGobG3Ce4IebqiqJz7G2JF2DZtwtcrOCMdXxuzJ3DHzp9uBNPxW?=
 =?us-ascii?Q?NcnCUtqY4JcXWbyX13xzz6aqd0zbmAVM3bJOs9qDpH4nm9IUmUteCuMt8qMG?=
 =?us-ascii?Q?whk6U40r0JiLmS9QcjvPOp8eVST7cVJHAA+0etpM5O0PnS2xUbgoObOh8UuF?=
 =?us-ascii?Q?yTe/tYgBt+F+aZMLGIS2uhwLeNMow8JcqDHS8/h73K/5gQCKc3I3Puf3fLHh?=
 =?us-ascii?Q?T09Fjy5nZmqzt6rERXYihdTSJtICdZu3K63vdUAnkcmNLBKFmKe6j8/u1jql?=
 =?us-ascii?Q?piLVeuyAyuOdXMCQO7iAll/KZ0cZRL6exyb6kyYeDK+tcfMzA4r5HGoru8pv?=
 =?us-ascii?Q?bDP39VvpxrDdMHDQB7KNVuAFskC3GLV4cvNKEe9f0Ty21gtsh2UtqYoLngBH?=
 =?us-ascii?Q?8TSiZKdSKK6YeOkbjd9XXAvqpoM8loBKjr1fbhMsJqrkwBtN1NgRv44Aezux?=
 =?us-ascii?Q?u0a7p4fL3W6whhxpbZdxn6bwkb2i6ViRxB+edC0SaGhsG9IwSod4E6RT8Sbf?=
 =?us-ascii?Q?zXSE5YdEljSABrAei7PU5iK4WYj2449IcglE1tCwb1fMs6TCxZWIrvd3TsSy?=
 =?us-ascii?Q?xZeUYuBKg+XM/UJuV+SnH4hpgUs77laq3J94IhANGi4NG47b4wjMNIx9ROoN?=
 =?us-ascii?Q?XbBg/CpMakzLt+N4aBD4/aYUl1GBiO5uBjMGj17l5H1YKAe5wnC8QJTCSrYU?=
 =?us-ascii?Q?/ngApf64UHmFHd6odp5z2lhRKVn/SCSGyvaFsYBJzTrqEeVPc7zdqsexW11E?=
 =?us-ascii?Q?9K3dqxuPbDAFTPvYMtOvpMbhwLpEs33chYd5bE18suQpGhjhEHcJQQfV6CLC?=
 =?us-ascii?Q?4dKJs1kb7Jjlw6mwX1iqxXJ6UjDXVqv74nVafqodUoQJIOd3tYb453JK4jmG?=
 =?us-ascii?Q?tRTlNcADKpyG/Cb1GqbwwotqDK9S3raLEtWtjxHoHdy2xmvvUQ9sFDfWN4NQ?=
 =?us-ascii?Q?tNSni395A/Uut6hXpkToX8kppNbSwPR4Sql+9KfxY4+rDDq3HRcOHoBlheuA?=
 =?us-ascii?Q?kJBgmnl8jCKzQu//JxyKAEuWxY7OErOk8sxn7T4v2ZI4jX7kzhFvnX+TQXTx?=
 =?us-ascii?Q?kut2rFRbsqU5n/zgkCcn08OJRoWqlRNxZkckmKCJFFWZbf4N2cQAGQI3ndYf?=
 =?us-ascii?Q?tulmiKmZJq/TM8JnY3atWDG9SiuhJX6ChiPjbc6anhl47Zw1UPLoxbMVNmMH?=
 =?us-ascii?Q?eNk/wIN+Wx5YsVIEVWL3/Rl5F2jDjQcSnv4GoHSewZ+MNs6DElNmi/lOnNdW?=
 =?us-ascii?Q?uNK4x04DDVEZERgHjrs7ysITGrwBGzyQMNk9ARAoGZiksTEQaw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29F834C9EC58704AAD9B730F40D60E24@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2357.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7463f76e-7da1-42e6-a622-08d8e3f2548b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 18:28:41.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PD4o1tpgZ72IJml4F2fFLLyyQT3hwj8n9v9sOCMLET3kVnNgdIo1aNCoqUMw3p7A2HE6sOTLKrf+dw6dNxhqFRGDsETiNl+MKRD/Y2NP370=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2261
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100088
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Nice cleanup, IMHO.

Reviewed-by: William Kucharski <william.kucharski@oracle.com>

> On Mar 9, 2021, at 12:57 PM, Matthew Wilcox (Oracle) <willy@infradead.org=
> wrote:
>=20
> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 326 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems
> on other architectures.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> v2: Fix CONFIG_SWAP=3Dn implicit use of pagemap.h by swap.h.  Increases
>    the number of files from 240, but that's still a big win -- 68%
>    reduction instead of 77%.
>=20
> block/blk-settings.c      | 1 +
> drivers/block/brd.c       | 1 +
> drivers/block/loop.c      | 1 +
> drivers/md/bcache/super.c | 1 +
> drivers/nvdimm/btt.c      | 1 +
> drivers/nvdimm/pmem.c     | 1 +
> drivers/scsi/scsicam.c    | 1 +
> include/linux/blkdev.h    | 1 -
> include/linux/swap.h      | 1 +
> 9 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index b4aa2f37fab6..976085a44fb8 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -7,6 +7,7 @@
> #include <linux/init.h>
> #include <linux/bio.h>
> #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
> #include <linux/memblock.h>	/* for max_pfn/max_low_pfn */
> #include <linux/gcd.h>
> #include <linux/lcm.h>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 18bf99906662..2a5a1933826b 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -18,6 +18,7 @@
> #include <linux/bio.h>
> #include <linux/highmem.h>
> #include <linux/mutex.h>
> +#include <linux/pagemap.h>
> #include <linux/radix-tree.h>
> #include <linux/fs.h>
> #include <linux/slab.h>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a370cde3ddd4..d58d68f3c7cd 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -53,6 +53,7 @@
> #include <linux/moduleparam.h>
> #include <linux/sched.h>
> #include <linux/fs.h>
> +#include <linux/pagemap.h>
> #include <linux/file.h>
> #include <linux/stat.h>
> #include <linux/errno.h>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 71691f32959b..f154c89d1326 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -16,6 +16,7 @@
> #include "features.h"
>=20
> #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
> #include <linux/debugfs.h>
> #include <linux/genhd.h>
> #include <linux/idr.h>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 41aa1f01fc07..18a267d5073f 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -6,6 +6,7 @@
> #include <linux/highmem.h>
> #include <linux/debugfs.h>
> #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
> #include <linux/module.h>
> #include <linux/device.h>
> #include <linux/mutex.h>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index b8a85bfb2e95..16760b237229 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -8,6 +8,7 @@
>  */
>=20
> #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
> #include <linux/hdreg.h>
> #include <linux/init.h>
> #include <linux/platform_device.h>
> diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
> index f1553a453616..0ffdb8f2995f 100644
> --- a/drivers/scsi/scsicam.c
> +++ b/drivers/scsi/scsicam.c
> @@ -17,6 +17,7 @@
> #include <linux/genhd.h>
> #include <linux/kernel.h>
> #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
> #include <linux/msdos_partition.h>
> #include <asm/unaligned.h>
>=20
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c032cfe133c7..1e2a95599390 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -11,7 +11,6 @@
> #include <linux/minmax.h>
> #include <linux/timer.h>
> #include <linux/workqueue.h>
> -#include <linux/pagemap.h>
> #include <linux/backing-dev-defs.h>
> #include <linux/wait.h>
> #include <linux/mempool.h>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4cc6ec3bf0ab..ae194bb7ddb4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -10,6 +10,7 @@
> #include <linux/sched.h>
> #include <linux/node.h>
> #include <linux/fs.h>
> +#include <linux/pagemap.h>
> #include <linux/atomic.h>
> #include <linux/page-flags.h>
> #include <asm/page.h>
> --=20
> 2.30.0
>=20
>=20

