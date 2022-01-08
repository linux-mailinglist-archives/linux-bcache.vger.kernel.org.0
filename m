Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31197487FE4
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jan 2022 01:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiAHAVm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jan 2022 19:21:42 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40794 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231809AbiAHAVl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jan 2022 19:21:41 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207Ls0SK029039;
        Sat, 8 Jan 2022 00:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XqrgjdeirmUOLLvu6Ln/DTf04cRrt17j8K11HRRo0YY=;
 b=xAw7DiAY2Oabxs6MyykGRC6Qr24pBmD7ke/vu1N5ic2H4/cl0idDPijSAA5wQF1DX9s3
 45eQvcZ14szhPmXrbnYKxI6CZCUj/z++oWEVyAs8D5Rvix1ns0PwvP9ow3OQWW2yT1yo
 gLxD8PEoCAPAEXonu6Dv603G09j6ADJAw7KIfEnSDrbhCmv+bpOMvIQWezGi7oqCd4ud
 HDonWuvsv7wwsQOY1pfslHj5I/Vv2WuOfpa8sHJ3oitamlHFFb34/Sm2ZAtDqeLf9rk2
 X6Yf195gb16zvnKsLdJSLwCbCA+nDCjwlqG1NUZyNg0vS/kmfi+dfDXs2LNCkeNpbU51 mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vbbacp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jan 2022 00:21:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20801m9l064475;
        Sat, 8 Jan 2022 00:21:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3dej4tg2wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jan 2022 00:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBhIX1LoxutMZDC72da46jNbIsdgSQAlobIefPxSNOkrnQhQViz20sY0yyjGefPgK0Oue0dQFibHVmqElfgcZyrX/O8qGd6gQIMSgmg38qAi1Baq1NVGcaLCsBywl2xN0cgg6mXHWxkxhJtOPUWq4EVdrqPYWX3nW2kmcuweMisIEArJIXJHgL6HpseRahUBcWjdYlRx9eFtt3aZk+uI2lHX83oduTWgDStZzv8PPep9+P2DsWsESbhDbEUn49/T8ATEDhlyruzTFJNxtutZ3uxI97xEzmvmSrkEKYzijEP6BJWjsxOnDn/7F2OdzFSo2hsHwjWBe+xydCxayrcLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqrgjdeirmUOLLvu6Ln/DTf04cRrt17j8K11HRRo0YY=;
 b=oOwq/rZhPyVvYZPW15UbbwCykpFqST+Ik1lv9MY5IcPLzXaeFxeJQ8C88IT3r46lp9HPm+qEn6UhBQ3S4MSm0YwsWQXf7uUKcgmO3lQiVg2goDwj+tHS7Fr92FJGFICDDG6F4a2MvnqYwV+Wd6pkUuayyyJ7VCXVRsIFYloKIXBRs+1at1sJ4bclhIvA0woAlSSnaaVC3xZ94vZNwBihAv15BSju4kUxyZfTILAfdP/MaPUElpkb04ssLUFAeqXL7WHaziahzY7ejnzzbpvVrBDRwO8DL6FxQVguZcZv4bw0Iq5sRmnbIJkPNIPH6Ht/Vz0+DDY1gvApdmofn8NRsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqrgjdeirmUOLLvu6Ln/DTf04cRrt17j8K11HRRo0YY=;
 b=Hz+HTCitrlEOCUJ8uQ9GraDuh7pT5yAI/uQ+Mu0NTv/ut6eCci+Ez8kpgV6+uBswo2ABrUwYensqpP8DHT40kD110VQONkGKfG6R4D3j4wmJAcPTLEn9jNNYrvv9ev+/4Wm1UQc5g5v/vJEN14OeRvmPCq8kwI+aRSMaYQFjpkA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Sat, 8 Jan
 2022 00:21:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4867.011; Sat, 8 Jan 2022
 00:21:31 +0000
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
        <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
        <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net>
Date:   Fri, 07 Jan 2022 19:21:28 -0500
In-Reply-To: <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net> (Eric
        Wheeler's message of "Wed, 5 Jan 2022 19:29:05 -0800 (PST)")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0001.prod.exchangelabs.com (2603:10b6:804:2::11)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 121dc24e-35fc-40ef-d3b5-08d9d23cd227
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680CE34EEAFBF758A00CC948E4E9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWY8zMTP4zNM1evnz90sprg2EkV5LGth1DP9DYU7XcsxGMCg2aSWyfbMl0C8Vu/HK8t/PFwxfYgBDa1in0BslJ/2ce4IR0aWp4t/l9r52dDzbIYyCUjMOeSLCXRyMKfNWLcwwsOAZhmPE+kwobU2ew5cGQODnxh3GONe/fupJQhdyb22sv262tLER84R0/jKbX6eg03vK+HHDh5FzN2XgF6QgYtWiTmgaw7x6y5eak9CG/oBf/1mTcgG8KbRYypYPKBU48jplvIdbPkSR7FiIf9KKGSh3T3FjhQsiDEKh9XmA4j9LQKwx/usD1zpWsIlvsuKLBRwL8Au/a5NsE9GvXsYvpO3c5LJcGMSYFoIHSIg+onyP1Fy3H9TfE3EEB5eyaVQWlz4nFUTR0M4h2zHGVm0D1b4nDBfjFdZo9s8qMKzQ9/usk56UG4weG/Gc5c4OTrXcIYWd31yayGE7mBAvv6DxKLUR+mE+oneVydoTiWzMBB1DhAJPXK59JMyjI7eOdhbZTG34feAEw61XH+w52RoELueuPUovAKw1ss0nzB+4tkJL1GzmpBBe2Jl8Ozv7FRLDzehhYxYTKhZx2ebdAbZI5Uw4oAYdvPS6uXZ8x1IQfQWu/HVEw9b+faapw+e+YGOisB6Q6tXybiGX7y3PAF5+nYoamwVYcW7ZvEJKrDUXqN3A6PcSzmWejJyLTSTWyFoaCqNPDYFMQytHKFamg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(6486002)(316002)(66946007)(2906002)(66556008)(38350700002)(6666004)(38100700002)(6506007)(6512007)(107886003)(26005)(186003)(4326008)(6916009)(83380400001)(8676002)(52116002)(8936002)(5660300002)(36916002)(508600001)(54906003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ik4jk7PQP2G3xXstYWpsC0lmvdAArm4QRRgP1bbYZ1BtMHMkGGnC2z07mYaA?=
 =?us-ascii?Q?4hbGVXB6UZWO3jHkFKh/HELDJ3xnbHdLS9nm4ctTxBAjhDTEj7ZtUrK6gGZV?=
 =?us-ascii?Q?INPluJGFgKkgvi+IxSJRhvLLqgM4o7dM3Ag0+701XGKgAQXoHyuBIewdOBdx?=
 =?us-ascii?Q?0hqQZtPi/W7zMfl5MwaVV4YCyGV/UetGPo/4JTR+zT+oCT/hVoTBxUQsoCMh?=
 =?us-ascii?Q?I5Mf4SFNP+k5dX1pX3pWgN6os2fTIUNec3NKAb71oNhcIql2gJVtAPz0ouao?=
 =?us-ascii?Q?WTD1f6rLIIt0OqreipVEujqBs2CUcnl0x/DuDBjKz9z29fbSF++DLXBh0w1S?=
 =?us-ascii?Q?BR8kYXSnarW/614WwA5Ca8dPSoUiojPVjQCR9AvvX87q/ETqg4t7CT4YMg7s?=
 =?us-ascii?Q?zNXrl9EoajJ4p3YGeLotzX9OmDoDVoBCf1nc7y7a/rNGkd1LsiThC7miX2Zo?=
 =?us-ascii?Q?oUWjX0jcK+iW3pEG7oKRoGnae5924H4gkks7iXIl1hoqbH5eDJl0Q6fW1cuS?=
 =?us-ascii?Q?0RQmziGw+4LpM6ksPWSKvLguzjtKWDzBsjpz9msaQmF1qxvCUqQgAdXMEJ6X?=
 =?us-ascii?Q?LHPwX5Fxt5eIo/D0HaRj8xeeN3utJ3ePYrpwiHKuRg1RtPvnvYJw5WY78RC3?=
 =?us-ascii?Q?Ouo1XOk40Cjjv/acALp3r6L+DyaMCCQikNcCD7ezXbz3L8NTEp/CJn6Wts6r?=
 =?us-ascii?Q?bkkuzenZd9ssW/1d2MjyL8n3+uQyCBGQHLeOzDUHprcPoKpjFBZGjdWuPoMU?=
 =?us-ascii?Q?SM7F9RFWKXYEiscu8jTMA2IK69KMHcnsAFHZWslT51kf7aYUnoXJOvkzWcIj?=
 =?us-ascii?Q?/YWsGJY2/AQzoZI1RqJGnvNm9z5XGUe/mbv4byAtxsx0xTc7/nnBYtZcT/7k?=
 =?us-ascii?Q?n+V2B5YjJVgPimGfLFBYuTuXeyYeExQxB6mM7j9WYV2+p/WCHo/7EOXKD4FA?=
 =?us-ascii?Q?vK8bDvYWQyGA7Pfo/S6WVYhasoJ/4fxmhoGWQ4ljPqV5lBV73ye8orFKqYAT?=
 =?us-ascii?Q?X3B2uqhcXAFOdxiclRHjlpTEUKJuYaFPKV7TRhu7xfvK44w8hogv2WLgEahb?=
 =?us-ascii?Q?uzfxOOb+l31CKUk3isLQxFKLHikieDjBYH2tuIz56pVrEB6TeNUNjzx0laeR?=
 =?us-ascii?Q?NwnTcf1hl2t0cHiM1n+wpwxzJiakRED8YxpllK3rSyAsIXFqPSOhgA6mW/ML?=
 =?us-ascii?Q?Zei+3CO4Ib/zy0naIdPTsvQaBNz673TKQVYtkAXDxBA4VJeLlNcOxiEMGUks?=
 =?us-ascii?Q?FaovtA6zINrDeJdvpVYp4LFg7yoNu7G9ZP2UqMGbTu7K5aRMDTu75dXxZg/q?=
 =?us-ascii?Q?yBMuvAI7ccO/iF+9RSzpEXJK+ePuY00tTYy2rH7SDZeZ1Igw7gNWDAX3Nxh7?=
 =?us-ascii?Q?JqKekuV0muy/gNqYP3IsAifrKPRfZ8/WimSngX8gdLmdntGOv58ZGvL/eVUz?=
 =?us-ascii?Q?a15X8y+DmPoNHdrrpuQrWOLV3yX80hJBsRLG1K9n5jjIiDL+Lbqg6w8K8Fs0?=
 =?us-ascii?Q?ycA2P1Uo3kbAYfJix8OCGNcAyyOKvgn5BHhCdViN5J+4Ors6WSm4/ivf15aQ?=
 =?us-ascii?Q?TuNT4QIYMjd4xgwvkmdFvtpebyRzuhH9oQ+5Uifjcx9qx1To2DAGLBtCXhLt?=
 =?us-ascii?Q?bG4bFK1t2enxMA0ohJx8Llb3ATT/pxzwdLhYsIkDnHv0WwlzN5yULF6BPSFi?=
 =?us-ascii?Q?67ccqg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121dc24e-35fc-40ef-d3b5-08d9d23cd227
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2022 00:21:31.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJrIbXulQ6StTMUefIEOSghXVHMUcHA3M1qvNP8Wn0wFsKt3+1F+kDr7sIm3fxn3mrV4NXGNo7BkY0/h1coTwsAkIRYbPSyVYHSAYQr13x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10220 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070140
X-Proofpoint-ORIG-GUID: dJYvrOy5FGYEB4YUnP6yYk60QYrINz8x
X-Proofpoint-GUID: dJYvrOy5FGYEB4YUnP6yYk60QYrINz8x
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> Even new new RAID controlers that _do_ provide `io_opt` still do _not_ 
> indicate partial_stripes_expensive (which is an mdraid feature, but Martin 
> please correct me if I'm wrong here).

partial_stripes_expensive is a bcache thing, I am not sure why it needs
a separate flag. It is implied, although I guess one could argue that
RAID0 is a special case since partial writes are not as painful as with
parity RAID.

The SCSI spec states that submitting an I/O that is smaller than io_min
"may incur delays in processing the command". And similarly, submitting
a command larger than io_opt "may incur delays in processing the
command".

IOW, the spec says "don't write less than an aligned multiple of the
stripe chunk size" and "don't write more than an aligned full
stripe". That leaves "aligned multiples of the stripe chunk size but
less than the full stripe width" unaccounted for. And I guess that's
what the bcache flag is trying to capture.

SCSI doesn't go into details about RAID levels and other implementation
details which is why the wording is deliberately vague. But obviously
the expectation is that partial stripe writes are slower than full.

In my book any component in the stack that sees either io_min or io_opt
should try very hard to send I/Os that are aligned multiples of those
values. I am not opposed to letting users manually twiddle the
settings. But I do think that we should aim for the stack doing the
right thing when it sees io_opt reported on a device.

-- 
Martin K. Petersen	Oracle Linux Engineering
