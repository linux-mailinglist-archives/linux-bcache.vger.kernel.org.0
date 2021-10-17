Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89EF430650
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Oct 2021 04:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbhJQCys (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 Oct 2021 22:54:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31318 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235798AbhJQCyr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 Oct 2021 22:54:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H00NsD011778;
        Sun, 17 Oct 2021 02:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Pl/XfbWyXkO9WxOahSYpg/veQLO34KTMKHuf1fPJlq8=;
 b=H9Mcbv3eP2B1UttHPG6ujNWfe65zpOleRDKOm0xSxkpkd1AN0askNKTnQBBE4E0tcIfQ
 7dUUiSp7o3esA34K7OpgfQSJrxgWWUr29uenPzcTKf7WOeEqDt0miOXyObT208fnfGuH
 3XlnqzBmaJtH181W5ERL0eINjs0UoPmyqIO6Z3uu7DIQbhuNIEQfTQl82DCdH4scu/Go
 5L9C81K5Uzi195lm7ToiudbAisJLUHtpDkl9c8smzG0UVvqYrEBWdDHUmD5KahXcLdKJ
 1hkTc4MUDW0SBIooUJ0+Od0cma0C/qLyNyFUwvMbl2/yFrgvW0H7cf+cxkUrmGkyn8Zt ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm49r8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:51:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2owIY152011;
        Sun, 17 Oct 2021 02:51:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3020.oracle.com with ESMTP id 3bqpj28sfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:51:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNJ9tEeVny6bJG1CtMZsR5mFoJuDAKQgkXf+GMg84r5if0jwscRKFtLC0lH5aghZbStV1/XZyKWOjCPpdBpOs8OQLs9DWDB2DpxKfyA9S1NWJZEPQjFSvr3W82u0+d+jonOh0IAdeL85FqPqMpuFpMHftMfa7sxtMaAbximweZTzb6S/B+5BKjFmm8pnr0R/6STyp3cJIRBPRKtrcpEhVSXp4aylp3P64xsI8VJBMozCyCkORVu9ebMPHVdAQxzpBtuiOCFJvvgRW4yTOHuHAq0fOcwfE2V+7N2em0XPTpnPB+hp3nIJla4+1jnnmFpGDrstkebUsd4XQJB+WXHz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pl/XfbWyXkO9WxOahSYpg/veQLO34KTMKHuf1fPJlq8=;
 b=nnqS5R26xbyePPq72qzvymPOo1lbWOdLzbPeRmeFkTgcD7SNXBYz1FgidtxeRbK74r/hwHNB0TDAh37PfqbEVYuIZJSvOhgPRBcR2bLiE9sKVlFw8O/opsQLam5a29Z0RVBg4sLH9OzFwiR4Fsoi9ncp7xr9t7Ez8TcHDc7xCwHv1eQGVukb9pFH7hGX4tva3mbkvHzmIhp4KbsVpjWE8WK/VJ5KolPxcbpyWm+uJJzaieFbNkPdd5kps8VmUP4ZFpcQst7YIaEIhfFm5oq0++JmN+e3cBbL24lFxfaXba0WCE4ULVD/AlQnHRpAzi71FfP3VQAbXEbi/FFM04ShAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pl/XfbWyXkO9WxOahSYpg/veQLO34KTMKHuf1fPJlq8=;
 b=U6wB/PueCe5NeZIGjAnH9guPdczL981YavurwbH81sFGMm+ztjYU7F3h4bvPy8fzjMzCB39VMRWUB+17nVCnCCc275SVmO4YAbN5rI4kLUDQlgDmJqHALxHBW3moCy9s2SwNCOhfYNnWwMx+lTJW0Gum+2GQJLHezoUHzrAuvOo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:51:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:51:51 +0000
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
Subject: Re: [PATCH 1/9] scsi/sd: add error handling support for add_disk()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
        <20211015233028.2167651-2-mcgrof@kernel.org>
Date:   Sat, 16 Oct 2021 22:51:48 -0400
In-Reply-To: <20211015233028.2167651-2-mcgrof@kernel.org> (Luis Chamberlain's
        message of "Fri, 15 Oct 2021 16:30:20 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:a03:333::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SJ0PR03CA0105.namprd03.prod.outlook.com (2603:10b6:a03:333::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sun, 17 Oct 2021 02:51:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87750c7a-62d2-4af9-7bce-08d9911911c6
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55306D7AD1B871FDE590A8488EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+3QZh9zDXqbMpdWQQ/r85NOc5Ti89JpwExfWWPeOwMUQTWQzPmsvCr5wfJECIO/PO0Zma+QD5T33Op2EB5Qt0qbsEjMFbUp81rTL0WzJ9EUm+kdIZ6AqkNbbxlXFj/U+Yrjb8NBGn2jckdXFwJSIUvxHMFDuqdNfSQv2ppXc1zeNR6EsIsmJgmIU8uORpHOdThJLSKwp0OYoGbKtfuJEBCLoYbqath8C+BKd5cfrqoA8U/gbJPZbbhKO+2ZhJGeh2peLmMZmNbcjaQJqWY/8/Xx2lb3ZgJm8Ncgh4flggLaqAkTuknwiL8BkFKMaaltI5zYiUKb2oFpb29J+1MOmVcYQe+Y4iejXTuDgEHtpPlXMDX3ru6ayRTf/eX5DM4UgSBqN3gi66NcVUnx+7T2seNETumb6ZunepJdKQypSIJCHcj17Folhds9kKowKStACbc18fjqyeAQybYIV9YwNUSWakn3m+kUm5d7ympfQK2b3UmkBdFs4WcyTv8Ep1aeFCx5L95H4MbYPWH0zHZUAWZw9VsxC8N3rX6YFKBDOPF54bzNB9GkwSMQtCe96R4aRDVRZ3vnxjOSX5SS4m4TGP9wpLsLM2tfWis6k0YrXkg/axCUgF7e0W2J26kcHq0hG9rzcVCpI13HTnmN8eNJM9EZnVLKtfBy6CNDWMvcrebdqbH5RdVsh5Ph4Q7h22xKyx0n/53HZGfVZ6nn4FvU0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(7416002)(2906002)(7406005)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(4744005)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kbOcSvfAD3n8+/pgfNz4afbOzyk+4imAhPOnJpxkTf3ax8Y/1yToD7VQRkGd?=
 =?us-ascii?Q?qhE5G0NdN+zo2pCC9drM2JygrIoNPpoGovRXweaL2EbCA+De+5sdUcsyBZLd?=
 =?us-ascii?Q?jGHa1OqM4GlvLOtRjaYnnWidD3dBmlQumSh75LqqxVJ5UzSTiQqT+6YahZ5J?=
 =?us-ascii?Q?s/xvH33hDO84KdfO7DzT3JTAGoy7CA3Mia2s7GaOTGHd6AM6kGrBZrzX6KvR?=
 =?us-ascii?Q?MK6FtmfbbKape0swwjU6zXKnz4cBXifUakFq5qBvyymgGuo2eE+JJhzFoepf?=
 =?us-ascii?Q?+UmBpauR6B3q4kxogOriPhddWPLD2FiaL14AALtkRz5ths4GzWNsX0ye/2qC?=
 =?us-ascii?Q?gXsFs/z4d4tFR+E2PoWzaA3HkYbhXUSMUpuJ92GG7Hu0kzORz8UzMocu7MHm?=
 =?us-ascii?Q?0TxdEHtx0OpawTqM/wnBqIuSR4ClbvjGtQOv0B5nxiSSEffX8qcQp+e4qcAw?=
 =?us-ascii?Q?cLDUc6ZiLsYNeBjxxn9gZuoCaLRhbM8tcB+sGb+F3/5TGUd2q34h13YvVfIR?=
 =?us-ascii?Q?mFbzww1kiMt4kYtP619iZWrxN61cjjvnf5eJmjRjJUAhknFSmdFSZghfv4nN?=
 =?us-ascii?Q?Nh8tRig/u0wBGdqDw6NW0hpMxdTI0aPxUjGd1Fzjk8KdiDBzw1wB1oWTdOdW?=
 =?us-ascii?Q?5QoymXHRsRqottz1LAfEj1bqLQ4rKTF+A0iZLAgvKLFOTWA6oGhxWYBBRlTl?=
 =?us-ascii?Q?S1hR/x9rX2464fWOjw85GhE/H8/9bSwvAn96DxbaZDfO+uRQ/2kjHNxS4OLG?=
 =?us-ascii?Q?jnTIcXdbj43Rw3nKlFdDljTUHINRmhJUh/5yWTYC51BKORAV3UDzLU0wg+8Q?=
 =?us-ascii?Q?UVysoJld9Rjhw0sNA0uvROVtP0EJN/EdCef49o37CvkhfWTc2p1NbRUMRSjB?=
 =?us-ascii?Q?RDCV0SKTbSQ3bigKGD3B9wVouZfAXwcPldL6VXN4GYp+JSkCXRYlRmmub5bf?=
 =?us-ascii?Q?46VvObEgIjvWfUV93OzqOnTJvzGSRvZqeVNtq+xdCCIsi8+uQJfK/+1uT4j3?=
 =?us-ascii?Q?w8Vgv4G0vFoppxrjOdclGUnYDgVcONfeq6Xu4BcIWaUeGt5rOxkjx5QDx7vJ?=
 =?us-ascii?Q?HAK71BnywH+40DJvxrAYaE40klq/ZriRMX62RH5465m7szhs2eFx28akDjT8?=
 =?us-ascii?Q?DCWfQJKgSkEj0pVwbMCP/VtAocPU3L5tWsrYraWZCAS/xJD8eRkVSl52D1BB?=
 =?us-ascii?Q?slBcB2cYui7HayYCicaLOW8kMX/sOpnjOEP398XqMbm0RaBqL9xNXfx9s+LN?=
 =?us-ascii?Q?EPzGZ74dw3eACDizqTMgy0x0QjEErlUxq3bB0xSNUikrj4gP7hyWr/LxgTtI?=
 =?us-ascii?Q?soND5s1uxdkkWCoBILN0KFSJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87750c7a-62d2-4af9-7bce-08d9911911c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:51:50.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/ypriX/ATAIn+9bdvbRDsWuRS9rBK0O+rHMXxZXH5WW0+QSxhlFYmySwH5NeyKvdSQZMEIdkTc6cHUDMazsQtp0X7jo2SzeiQhTTssOTog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170019
X-Proofpoint-GUID: u-f9w0o21UbNSEkBxlEUvTP3SOw8xORs
X-Proofpoint-ORIG-GUID: u-f9w0o21UbNSEkBxlEUvTP3SOw8xORs
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Luis,

> We never checked for errors on add_disk() as this function returned
> void. Now that this is fixed, use the shiny new error handling.
>
> As with the error handling for device_add() we follow the same logic
> and just put the device so that cleanup is done via the
> scsi_disk_release().

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
