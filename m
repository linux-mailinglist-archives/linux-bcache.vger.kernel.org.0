Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108A6432BF5
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Oct 2021 04:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhJSCzw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 22:55:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32052 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhJSCzv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 22:55:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J2SWJl007657;
        Tue, 19 Oct 2021 02:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=q5WscohXE6hl8xO2BiSNQnKNBIB9w5cD1KUepAFbGZE=;
 b=br9u4Yj1dcDMmWH+RoAkRen6gBNlmYDqlew+XZYZak/J0Zl/dHuDFDAyxmpqqSwSVW2q
 y6cudBsQB9trwfuZXeQcqMemsyY8UOV11uUFOpqgkvHCmb9/Qv+xB7W6ZJSggvel+zLV
 zZKp0tiZSe3TR4kYwAh6jqcZSu/jQMuaUjsW5vE9VOjpKs4SXdQ0wU0m0z4JOMSgc5R/
 XQCBGT/prsTo4odw0GbOyeELK9ilJl12UAoqcG8oFkDCv8/AVSmJirrQUNsSgzq2c/sB
 AF4cKsH55BQ0WNS1Wxlzj0oMl2Upk3BMFh4ujGFzjZypU5+C0xfq+ih6zl/nvG4sUoIR 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnmf7xwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 02:52:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J2VUj8014130;
        Tue, 19 Oct 2021 02:52:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3bqkuwgp15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 02:52:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QL3Zc4b0LrsA3lsa/QKS9tojFOP0PoKtErWETowpu9GSGGpo1Xx1LEIYWoOBhROffgpkb+x7yJIN5vkkKHo6z7C9BNTAG/Fx/qAhFqvOJN7RjF9Z+1CLmhw4nWX0At3dJ87CNzb60h1s3X2IglfPxySAJULP1RpBUVaTPudL4rQMbMKKsFmrZEqA4RZ1dXrfTCxAhKZk/q28hHLH7NF0EjoQ/L0Ke1TBSEC5UCeUgRr8LWm4WUo9vaYt2BG1P3fSI6g9MAm7Vjq9T/d0RhAzes31onbZ3rV3lBFH+SpFu2JZ7jJUV7AYKOca5XPyGeD4+bDayxbd0sef22Vz56iDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5WscohXE6hl8xO2BiSNQnKNBIB9w5cD1KUepAFbGZE=;
 b=kkcnryQmJbx/DALsNBsBRN1f/dW6eHjjhUYUeV0akFirkrEHUA4puWZEa/LaYw5yFVv24ULNZdFiZjluvC4dCGN+7U88KLbxrKz/3UEiR0XCUMUbiBkClqom71X1dOvxYI+uAKTcXbmX5OkmpkfyIB4Lo6pQZxqRDJhbplod1teP9ATcZy/wXcRsyJIIHBMVed+TMnv655ko8oYuRFo4pOK0EIjAcNJB3ktnLuwHz+1VdSwM7reuwcqNXKW5lpbWGYBK6yQ1YGa6hRzspzA83gplP7EKa6G7//PHyDI1n9tEHZPPmoCd2eNGWcPXrBL8fif/2OjHizfy38c+yuWq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5WscohXE6hl8xO2BiSNQnKNBIB9w5cD1KUepAFbGZE=;
 b=IugBsrfwGeUU/5+qjE5ynmMmg8pSs6mwMMSALUkwAXMNWg9YOJ4CCCfLdrqky9xgS0WJjVFKIakrKqibenIMko+RUNzU6odQMxB5dD5hX16wNiF+qTpRELZSDKQuidcO9ytfU9gWSBGOcgP8JdhXKoiliam7MVfZrG1Cui1mrGo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 02:52:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 02:52:47 +0000
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, agk@redhat.com, snitzer@redhat.com,
        colyli@suse.de, kent.overstreet@gmail.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, roger.pau@citrix.com, geert@linux-m68k.org,
        ulf.hansson@linaro.org, tj@kernel.org, hare@suse.de,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        johannes.berg@intel.com, krisman@collabora.com,
        chris.obbard@collabora.com, thehajime@gmail.com,
        zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-m68k@lists.linux-m68k.org,
        linux-um@lists.infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] scsi/sd: add error handling support for add_disk()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pms1d8w4.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
        <20211015233028.2167651-2-mcgrof@kernel.org>
        <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
        <YW3ZuQv1qpIXkd5b@bombadil.infradead.org>
Date:   Mon, 18 Oct 2021 22:52:44 -0400
In-Reply-To: <YW3ZuQv1qpIXkd5b@bombadil.infradead.org> (Luis Chamberlain's
        message of "Mon, 18 Oct 2021 13:31:53 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.18) by BL0PR02CA0117.namprd02.prod.outlook.com (2603:10b6:208:35::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 02:52:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f71b47af-e5d2-4a46-cf55-08d992ab8837
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612CBB25690C25EED7375268EBD9@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGRqMuGIFJtch3sQkmWNIo3DxaSILxOgnlM6Yyr2SchOySNj8nd2dFjZeggnQrQHnf0pJTUT/ocWogUWcOcA4QXGGPCO3d3fnVvljJLK1gcuYugYQiQmpUF8gqYhyaOBJ5q3PMa5L0aNAjQ8A6UM1cytzeEK91RBVo4Lezz/KDiq9Y/nL6b8BF335UGkR6okyTJ8lxJJ5tAeYK29z4Akz6h0MWBETdXf8YUQ8zp97wk9fpQhb6x0mOoxMitCDiiuMnBvtbdFz1Zwjl3IpCMM3A/37OMVxqtyQZ+vZ/IaiAmcf7hSq41yfaswC1WkTSp5LNhaRc4rKYCU3MFaKqjwtphIYR8UPTHDjTDV0jr3xr+9F8OTWK13cvQtCRs9QItpJnbcZ/c2aqmTZe0tgeGe6d2Ky3/Lz3qNfmTLP/gaWzSZMcD7LSNlyreE9XibY65mtsWnwErdvICIPMiNZCcIODLa2bh/KsEC46hnHwazOSdGPg70JW3CMNLnYnG/sgAlTknfCp9kHKjn07jvqVLWiIHldwVKzL3fOzNdjPScVtOEo1HBH2oV59zMJakyVyfit54YaTpDwntYdO0MnslQiSGhOmLBe/JywHT9mFL5nxEWAzATsXFCgUMH2olk61DCAQ+L0SbLkWVaODezLLDPgf4npsnKRElr9/9Fur5tzsXH0UE58ao/mGzxY/IbjevFnmtc7pXnMN3TGhT8c5xr5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(7406005)(4326008)(7416002)(558084003)(8936002)(956004)(6916009)(316002)(2906002)(7696005)(86362001)(26005)(38350700002)(38100700002)(54906003)(186003)(55016002)(8676002)(66556008)(66476007)(66946007)(5660300002)(36916002)(52116002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meZ11y0UqDFMVR8LwY48iHN+B2ZAJ2DS7unaUAOmJQU7p1kC0uyKI0gpGOCz?=
 =?us-ascii?Q?gsgck0SSO1gEbziQu1uWrl+Himk4wJGBH1OY5hPheMyjTgbcoiSwKIGoK58Q?=
 =?us-ascii?Q?x4Bv0cLGCehVSC+FPwGO/sQZhb3mArHLehb88qPj57a4uk77Wu5MUI6UOM0F?=
 =?us-ascii?Q?0O7P6FALq9Wp9spgA6Nf4BzthgZsQKy1YTY1Q6b3UQqimzDL64HCKL6AvAgI?=
 =?us-ascii?Q?6eVQxKFxCTXIo/DTUPICOdRi9Tx3XVbBj+OeteYg/WwZJS8PN0Rs3Da8kluO?=
 =?us-ascii?Q?4tgJJcW8fSsHbf4nlAgsD0C696KyfwXD1uKEIs++OmQTWohWQ0kKqnwtjXnt?=
 =?us-ascii?Q?N4XFQZ1lIz2ICesiP0tu/vAxBDRm9cQzx+IDvWzUbozEyZnFVVMPAl4DPAOc?=
 =?us-ascii?Q?oqH4LFRf5T6HvrJ5Iw11Ra+Y1s299n7SG8HMBRUOPy8Q07KvKwWiNmiq+9hR?=
 =?us-ascii?Q?Sdcy1uURx6A1AHnMX7mGvmFMzyPok+M+SJFXNZ6DZ+aM8AgBETwXp+/9KZis?=
 =?us-ascii?Q?NqfkW+rbNXztE9MSFsVZXXpvcxOcs6RPhqhN2soaW4FpkKde4RXxNbRVp30T?=
 =?us-ascii?Q?pWlreM7OGFjoWA0LvBuhsqbB9m7D3QQ1FddMY+QbVXGIaUP+AdPfRfmbBVEl?=
 =?us-ascii?Q?yOWq6iWvEk2vY2/zCYERhU7jeHFHoo6LKlCj+vWWr+TM0yTvYlip/UIMz4ND?=
 =?us-ascii?Q?+OR7uwDPTTidJLmDMZd3+MJf+QHKL3IeYG80KLmdmixaaZUF6Xyg62Al3Dql?=
 =?us-ascii?Q?xCflg7F087vsKPR/C889V5dOBDhbA9NKie3gyMjdXA72rJ9xtIjNBiEP9KlZ?=
 =?us-ascii?Q?QwxL/xXzxokdkA4f0C0yyJtN9XpxnHM2zeRuUbNecKIbP+S4A6WQmZ+quRuZ?=
 =?us-ascii?Q?0qz41NwM+aOvEduibJ8N74tbbKYRvRpvi1cIA1GD/LOL3bcIg45du1F1TnL8?=
 =?us-ascii?Q?SRGkAEhM48ZgaSWxbGQ/1hOQRXBtHvVF5oUpFCV5C8wMiH2uXx4kSVKllMdK?=
 =?us-ascii?Q?geoX2J9XkEkkJeHyyvU+hDP51lRTtLuE7nc2WdGn/4mqQ6bC1MJPB6uILkpi?=
 =?us-ascii?Q?kNSAvUFkprFOlioF134mXjvjEE8+tHxYjwi8WXig9QCAZJZQmcFp04tBhC6z?=
 =?us-ascii?Q?zx1QbiUN7GphDTDan1y9GrPioq4KJn7u6v6Z660EZfYqv0X2m3pGIJSiI4W5?=
 =?us-ascii?Q?P/Jn9yK41w+maH1Aab+AbY6URwpqQZXJEbTEHP4/DNN8u3413jzEXsLlOL2i?=
 =?us-ascii?Q?/dCFFzl0tenq7PK/3GMPK83gHPWsvRGAcxvcBBahfbks7TmgtnYueW0N1Htq?=
 =?us-ascii?Q?hbVqXAGYSkZLXKtP6Jl1ehtN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71b47af-e5d2-4a46-cf55-08d992ab8837
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 02:52:47.5144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxwuuPShKyKXOVCuyR2GEPaEFztujWky8m0/kKzFB0dIBmxOllLsoIqtc8AkZQ5sw3Tbo/+nRP1sD53gpaCIctKMLHtP0WEm8WEs0NXOia4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190013
X-Proofpoint-GUID: iauxcMEjFutpKRN5OBYZcn6MHISXq-QI
X-Proofpoint-ORIG-GUID: iauxcMEjFutpKRN5OBYZcn6MHISXq-QI
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Luis,

> Thanks, would you like Jens to pick this up and the other scsi/sr patch
> or are you taking it through your tree?

Didn't think I had the relevant add_disk() patch in my baseline tree but
it turns out I do. So I queued them up.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
