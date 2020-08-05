Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8545B23C29A
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Aug 2020 02:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgHEA2v (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 20:28:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50794 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHEA2u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 20:28:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0750M03o127467;
        Wed, 5 Aug 2020 00:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=wDDhw4JoPLvk6HVCNBu8vh6YWhhbKaqSASVf9ZusHfo=;
 b=En/h5OWrgjseryX0WtFrf1skAXSUZg0T4UCHBeQ0A9ZW6MBXaL7J/EHQP+Nq1hZw1cGn
 0Z6v7KjEo9+QzecTn4xA7/73WupPWDSwGBUmMS3mn4AM1AaggyhA3+4Mdw8DF8p2byhi
 iOwWXyL0viu4LA4D7Boe0qVv90udg6CGIQa4/Uc0e6i4SdsaBW76euox1GgxTPZ4ccJR
 sKVPmK6ZMmoOFuV+uw9Ovfg8vWbtj9/sqH8nEa6jAHno81+8szl2TT1V2A/EPQBqidtk
 D8ZM4SVfGpZMx8Sulrf83bwyZNY6jjDiaZNkwV/3jqauQmspSFG4yaveeo+UqYWTJyci xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32nc9ynvj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 00:28:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0750N8MJ132754;
        Wed, 5 Aug 2020 00:28:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32p5gt04g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 00:28:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0750SV4X025572;
        Wed, 5 Aug 2020 00:28:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 17:28:31 -0700
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH] block: tolerate 0 byte discard_granularity in
 __blkdev_issue_discard()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18seu0wdd.fsf@ca-mkp.ca.oracle.com>
References: <20200804142332.29961-1-colyli@suse.de>
        <20200804235811.GA1981569@T590>
Date:   Tue, 04 Aug 2020 20:28:28 -0400
In-Reply-To: <20200804235811.GA1981569@T590> (Ming Lei's message of "Wed, 5
        Aug 2020 07:58:11 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=1 mlxlogscore=808
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 suspectscore=1 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0 mlxlogscore=836
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050001
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Ming,

> What we need to fix is loop driver, if it claims to support discard,
> q->limits.discard_granularity has to be one valid value.

Yep!

-- 
Martin K. Petersen	Oracle Linux Engineering
