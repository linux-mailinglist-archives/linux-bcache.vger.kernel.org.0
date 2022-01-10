Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3230489D46
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jan 2022 17:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbiAJQOq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jan 2022 11:14:46 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50866 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237111AbiAJQOn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jan 2022 11:14:43 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AFTlKA014709;
        Mon, 10 Jan 2022 16:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=o4McD4CsWTlK6pRyixeg0G9yEK677N8ltCfKz/y9dAY=;
 b=d7lTOJc0jqluZ/NjP6aXnJIg1qZj4viIugSsVqMIow6pGVjH72+QVlc4RTK6584ZiTBc
 60GqA8lMmZG614oyxPAdWh1ugCeRM3rRlUO/1aH8r45uQET0UOVh8dttWP+rEngHyWHp
 BsgdcPKoFeTnpz4O/BxQHZtZZrY9Pd82wT2C3Af0ztDEaxeEvzA/5FQfGQsTXJ8zTkJH
 qUvt3K77dRxF03dU+9iTWnRHVq2EcUQcRNnMdHhqZhbeoByWo2h3KgCp5p/+7dJqoxAj
 1skoToRs9VMWG61aJl7FHYf8lUvUsI1KGfcgJH2cfqc66bzPVKw4fRg/U01/pk6jEc6I Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk98mfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 16:14:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AG5u6b021953;
        Mon, 10 Jan 2022 16:14:35 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by aserp3020.oracle.com with ESMTP id 3df2e3g23a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 16:14:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3e1A8TUVW/mV0g+VWZC5JzIzzq5wUrv5ho24QkF3ApH1/D2YB++es8aNWIAHpSHKuLGgfUllLI1vomsHjz0wyqFdEEJ4vps3QiuX81kJzma4VLUusp4Hhhp3V3jAj+1aNf/wxrmhP+6CINIddNT42Ayt/zOJqla6vjorn1wmNBw44e7biqZQ2ihiqyjEOtK0KOAGTu818VTmHFrLKyTgaaWVULfo+NW6Ev1xmeKbUnElHkxjalOcL6pFCy/MBl4adQTilBKoJxYMZ0bidSasYncaun3ApCqPUrOwxtXao8gKQXYc7TLMg7LpA/H+6gjNuxJBKglECp169JTm5GC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4McD4CsWTlK6pRyixeg0G9yEK677N8ltCfKz/y9dAY=;
 b=hlElsbkFf1TgRk2dyBoUCJu1eWfLAAKfXI6J9NaIWhxrLaKu0xSTg+8diJHCD/uRgmw+DRMrIIT+k6cJpgt6gafZKfQzE2+yEkOtrvhH7bgF3gmA5ZegOoyCgGfIZWQLm7BmjkFlzCIJr9AugFMk8nzIhdVNPBIInrOZWnxHQ2TR5zqSoQIGLcfxRDP4C3ex6ZuJ9HeVzT2qNkOTRYsKabzGHrCUzK0QmbvB2pNa9Jw9l5fpOp9iEl289qHPVXSHzicRPSBqZ+PS5a//Z9dkeB23vfvuRVvx2t32IP3BeLT3JwHruX0TT39DjT9b/R01rTwffMPyEDEOiLvi7VRVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4McD4CsWTlK6pRyixeg0G9yEK677N8ltCfKz/y9dAY=;
 b=BmTdRoAzEuWejH2hqWOuzV+U1WV/W4OR21O2VsT+MzSbB7B8/WkSms60qO7LlCcRbANKw/xk7WajLznVN3AN1IW2rmxwPkT+62yUS7vCo6kChCVIU3co/NAFf6k/Nnfw6H0/t1qVmZE8eyF05U7yDxvFhWMirJxNxpQd7XFqFYg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 PH0PR10MB4455.namprd10.prod.outlook.com (20.182.125.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 16:14:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 16:14:30 +0000
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fspvshbw.fsf@ca-mkp.ca.oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
        <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
        <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net>
        <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com>
        <c9abd220-6b7f-9299-48a1-a16d64981734@ewheeler.net>
        <98aa1886-859-abb9-164f-c9eb9be38a91@ewheeler.net>
Date:   Mon, 10 Jan 2022 11:14:29 -0500
In-Reply-To: <98aa1886-859-abb9-164f-c9eb9be38a91@ewheeler.net> (Eric
        Wheeler's message of "Sat, 8 Jan 2022 13:51:22 -0800 (PST)")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0034.prod.exchangelabs.com (2603:10b6:208:10c::47)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e61efba-0054-4203-198f-08d9d454487b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4455:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44553E817229E2D103F407AF8E509@PH0PR10MB4455.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uti/h+0pFXGs6vC/EIkK+Fsrr9BrJp3VmKkZ/VgSisdI/o0lB22RSbD5It1mKhAYU6e/r2PcwdDXxJh6vyE0Rx3ySuoGqgxuwjPUTy+LoxLI7NY/Pt5hjpAFM/MVEOC7zJd4dTKHyZiHfKDWFdmzAzq7EZHKd9+JlZ9mjOqTC0oukluTvzF2Laysk+vmv89eQf8GKmUcp9oUhs4Vs8x3VSCuG07lFyC29lZiZYs8oiRp5P6HastIMQJz0Bv7e54oG1k2+zKtckKxbzea1UH7VT3zs4DF9XI+jVM/72H5TvcPk9r8iT125S458w5z4bTIoEkMnfVYhG7l/NLDCclMf9f917yjlytpM9gC32VRSQ63UBG2HfsQncr21JDgnw3t89bY8J05BfW8jI6ctTtPcPS7hXqK5+yPV8ukvyfKbCPbQsimnLWU8dMeGdN7HIP/btl9rtvRdwL4KLatoe2UDSwdMCs7+Ugmg3/P2HY0NLIcUHTNXPQKSP6kM8IeTBp+gmlf6C86huexX+z+UEfD+0YIfCEb0cLxlj7QMfKlOBcxM3tQNdoeADGfi1dUF3AY/NlAvF5YPJJzMTM9T/RlfxrgkJronkVu9fuaDsSNgsaD1yeXTU+CVeCIYUODjDH5A5yG561WlvWN+Ehz4w2UOd/J+R3GX4r+mXgPq/z1uUEnqMIZCRf6G11yYr/HZFa5XmJt5TJpzNaXEIFqeIdQYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(186003)(4326008)(52116002)(66556008)(508600001)(54906003)(26005)(66476007)(5660300002)(6506007)(66946007)(8936002)(36916002)(6512007)(316002)(6916009)(6486002)(38350700002)(38100700002)(4744005)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VyTD7W5sMHy98EhqSxv4e8jnEAYYqqIe+MTVUEx+VpzsxixaJtpavoGl1MUB?=
 =?us-ascii?Q?xED/Ggref6qfJ5td/3OHwTkaa1LLMMu6ctEfLvfFZ3kQGaVgWa3ZcgeD9hSk?=
 =?us-ascii?Q?gVlwdh8ne640GMpXlwkDmt0SHm0KZ6BDh4prLkYnNdaW9Xj3vrHMs9HmPOW8?=
 =?us-ascii?Q?JfttyuWf3rpseT0/UCG8JoqJOuf5TXhjFYD+P2IbmyID0qrNQTw/hQ0Rw8BG?=
 =?us-ascii?Q?41V5hkt13BJ0qSOPvxLbJwA5QkHl9gfmTragiFf5NbouxeWn9V4sJJhffymM?=
 =?us-ascii?Q?tIvb3ZEbkRT13n8GF9BeIwBMGPqCvJI5CejbTSenuL30gv+Cx7fyNooOxh77?=
 =?us-ascii?Q?I73O4OMPQch77khMZ0l3EYWtXSkvHSIcME/U6V/VMqvWjE0kBTdJ9IVi4SI1?=
 =?us-ascii?Q?jST8cx2EDfAvbb0YyP6n0xxgv0WfP6jZrH/0NNewZ2RdLO35VVxZlehCrabw?=
 =?us-ascii?Q?CBS6pF2mzSqtYvZvWaMgMkdjPSfslvO8cjr0hCv8wesbnIfi5djM8LjICOiV?=
 =?us-ascii?Q?SYGsYaAOfQn4w0XcLBAzZC3gKPsooxos/MU5ZlpDQ9ldIUEb0WNt8xtAgqmp?=
 =?us-ascii?Q?erFgF08FF+MybT73zgI10zKQv1l2/DiBcQ75bnfK9MovKT9eoXWxLKEBuBgp?=
 =?us-ascii?Q?KrhZ5Ikf2j5m1dbPQeJp0XMbs+LIgXjaLsHuT/wFDQ1O59jVHN3WFnywCa3u?=
 =?us-ascii?Q?+tnnfnjdOKyFNQpevnmPd3wU3R5+nbkM4tToQ5d+NxUjAQ3arL6xyAmbHUjv?=
 =?us-ascii?Q?koMA36p0adzbj//hPw2vnkcW3EffKkUuyKQhBvGeQSfzdXdgGJ5exZUwQ2Rj?=
 =?us-ascii?Q?nNPOvqSlut96MPJI7CmPyCNP/ltm5B/GEP5JJ/lncPQ7CwfoYazCzon8IpHd?=
 =?us-ascii?Q?0noC3j5DNaBtjTv9jzBFFY4LOzS6r/cjzcge3TIxje7FtDZ4dzVF2c6MP1KX?=
 =?us-ascii?Q?VGAlakn72pxlsRXMW3CCkf8CjuUSPccVUE7ENFGSVloZCbElhY8rC+zPklG5?=
 =?us-ascii?Q?O/1Uck2XkCRw7phSkz/XdZhgE03Yw9tMsVY9lCl8VTGZpBlrg96XtObShWp6?=
 =?us-ascii?Q?QX6qvIE03aLp/CCgRW26hxHCjaO78pHprh8kzz+Xm3cluKjloW4ARl/otjhU?=
 =?us-ascii?Q?8jP4YNyI5mpCVrvVn/7+88CSLx9Iq3ArLr5kTLumF1HVgIJm/0DNhhvBY9hw?=
 =?us-ascii?Q?m5ED68kq0lgpoGIqYRIWug0E2GwNUue2zaYfmuljKm4/yPxsfvTutTisnMmt?=
 =?us-ascii?Q?FOPGpekLukW1RGAb5gddk1/6wxP5ujFhfGVbHyhYo7G0Re6veHgvh0m2/UEd?=
 =?us-ascii?Q?qo3u4dPHR+JADlbDjM5eaeshKVgFCW/pOclyBjzh8oc3hg71oq63x34oGXsj?=
 =?us-ascii?Q?rhBdUf4GruOWD+CBB+17jmaP63+ut5+Sdesz75j4b3j2pAXHx7A/ZcDAEkZG?=
 =?us-ascii?Q?PXFEr5bJdwQCzWYoJ7iiHtlsez2iseZgpHMTDkuE6Bb9CO5ROXiVgGbSZcNx?=
 =?us-ascii?Q?RY6hBlpNmnrmqnStH35QDidfYl/P57aku5SUppmOSZTlio+sRcMdVuD+mdRN?=
 =?us-ascii?Q?kmMJJM7m+Z52mM7xZRepU8+z7vApATo9sU4EbTlISeq8MG8GWNpcKinFCZqT?=
 =?us-ascii?Q?oqG9gngZurfsZMTpw5lnoTF1QfrxY3o5b3jLjbVh3qv5Tn7NDeCp/zgwmxxQ?=
 =?us-ascii?Q?prBd7kAmxF0UF3Q2ZgVwnEUWTmQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e61efba-0054-4203-198f-08d9d454487b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 16:14:30.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jsJaZs/6bLGFKTR2IZ1vg70qLoxXKr+dMuCuWgFR4Ju+vdvtddmK644Gbb94cL+lUXNZ6EPTeaC2Zya1ygh9lWr+t3NiH56MnpfYytHKyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4455
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=823 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100113
X-Proofpoint-GUID: pq0ERfFr93DWdD4JG4ExAfVdH4Pf_2Zm
X-Proofpoint-ORIG-GUID: pq0ERfFr93DWdD4JG4ExAfVdH4Pf_2Zm
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> Ok so `git blame` shows that Kent added this to md/raid5.c in 
> c78afc6261b (Kent Overstreet 2013-07-11 22:39:53 -0700 7526)

Yep.

> Do you think we should leave the md-specific
> raid_partial_stripes_expensive setting and require users of RAID
> controllers to set the bit themselves in bcache---or---remove all
> raid_partial_stripes_expensive code and always treat writes as
> "expensive" when `opt_io` is defined?

I'd prefer the latter since that was the very intent of exporting the
device topology in an abstract and protocol-independent fashion.
However, I don't know enough about bcache internals to know whether it
is always the right choice, what the trade-offs are, etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
