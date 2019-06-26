Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1EB55F2C
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jun 2019 04:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFZCvA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jun 2019 22:51:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFZCvA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jun 2019 22:51:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2mgg6039188;
        Wed, 26 Jun 2019 02:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=AE6RYTrK+I5OPTA10wmaU4DvOP5vouFz+RVrW+se/Os=;
 b=qVcqxgkYGttKeLcU9M9zujInXCZy2LMCU7udnux5OWq5s9HdiDj1ak97oDRLynjGO3XO
 yNX4N7NHWJuYOk0dy4bPTEnOcuaY3eaHP/lbwHb07sRrsTapopiQUGVAU2i5binx5hOr
 TG9TDwmvSPz7lurX1N+P8sPrmCmeiMTSihSdq8tsL+f3uA6PdWg9behmEAFf4KXYRRPZ
 Knc0vRcHykFisuHMMQWDIvztT7AVNxt+/S9FqvM+47p3kYf+xaYqtKVIp1BuUjCY4GFw
 D5sbMIKPWxv85lEL+fvMXA05ReK90Ttnq4fjLWCDWPZgQ/362eINESPXIAsnCDfv9w+5 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9pqkr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:50:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2omOB054233;
        Wed, 26 Jun 2019 02:50:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6uh82r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:50:53 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5Q2ooFK031644;
        Wed, 26 Jun 2019 02:50:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:50:50 -0700
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:BCACHE \(BLOCK LAYER CACHE\)" 
        <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
        <yq17e9ao9c3.fsf@oracle.com>
        <alpine.LRH.2.11.1906260005570.1114@mx.ewheeler.net>
Date:   Tue, 25 Jun 2019 22:50:47 -0400
In-Reply-To: <alpine.LRH.2.11.1906260005570.1114@mx.ewheeler.net> (Eric
        Wheeler's message of "Wed, 26 Jun 2019 00:23:09 +0000 (UTC)")
Message-ID: <yq1ef3hm54o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=886
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=939 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260031
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> * LSI 2108 (Supermicro)
> * LSI 3108 (Dell)
> * Areca 1882
> * Areca 1883
> * Fibrechannel 8gbe connected to a Storwize 3700

I have a 3108 that provides the BL VPD. Surprised the 1883 doesn't.

As a rule of thumb, you need 12 Gbps SAS or 16 Gbps FC devices for the
VPD page to be present. The protocol feature is not tied to the
transport signaling speed in any way. But general support for the BL VPD
page roughly coincided with vendors introducing 12 Gbps SAS and 16 Gbps
FC products to the market.

-- 
Martin K. Petersen	Oracle Linux Engineering
