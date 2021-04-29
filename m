Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90936E4A7
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Apr 2021 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhD2F5j (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 29 Apr 2021 01:57:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhD2F5j (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Apr 2021 01:57:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T5sTMo189481;
        Thu, 29 Apr 2021 05:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hGTyGt9noPt67Cw1LsQXYDQXCJu92JsiJuvxMAxCMMM=;
 b=Qvmzx64VuqWu0acTsyHbvRzHxKl5/RQOnbPHfTSRFkp7TWHHvdB//von1yV+hujZSPRj
 TwgCE+c5VjNtfhi9JmBUHKETzqbWx3XtYEDhZcw56eM9jIeR0But4iNgR4BZkxkoMCTr
 JKVGyLt5+LK229yWP/mAoYlDXKRO4B9i93Ey6d5IEpZpNCk6pGoZyOpOHS9lH9CB+K7k
 lNcrpPIahV/JSNObMOpQMZQpR5WmnxVPJWg5vLAkETZf+ov+x5kwXPni9rzjglDk3Ilk
 4bIbTF8QXwQC9vh34TZOXYiHNAY3IrmQqJqBOHpSPQEUgQ/sbkp5qmOS39Nd9XsngP3Z AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq33ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 05:56:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T5sqgJ162583;
        Thu, 29 Apr 2021 05:56:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3848f0k264-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 05:56:43 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13T5ughd166809;
        Thu, 29 Apr 2021 05:56:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3848f0k25t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 05:56:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13T5ufk1022348;
        Thu, 29 Apr 2021 05:56:41 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 05:56:40 +0000
Date:   Thu, 29 Apr 2021 08:56:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>
Cc:     Coly Li <colyli@suse.de>, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
Message-ID: <20210429055634.GW1981@kadam>
References: <20210405101453.15096-1-zhengyongjun3@huawei.com>
 <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
 <d7f70ce31f6f61a50c05a5d5ba03582054f144fe.camel@gmail.com>
 <0b4b7c5cc2f19d2d77a66c0d2ce42f63692174d9.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b4b7c5cc2f19d2d77a66c0d2ce42f63692174d9.camel@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: kYTj2TlPmLhcVFf4NH8LINeIEXi0YT8g
X-Proofpoint-GUID: kYTj2TlPmLhcVFf4NH8LINeIEXi0YT8g
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290046
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Apr 28, 2021 at 09:19:26PM +0500, Muhammad Usama Anjum wrote:
> On Tue, 2021-04-06 at 02:17 +0500, Muhammad Usama Anjum wrote:
> > On Mon, 2021-04-05 at 22:02 +0800, Coly Li wrote:
> > > On 4/5/21 6:14 PM, Zheng Yongjun wrote:
> > > > mutex lock can be initialized automatically with DEFINE_MUTEX()
> > > > rather than explicitly calling mutex_init().
> > > > 
> > > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> > > 
> > > NACK. This is not the first time people try to "fix" this location...
> > > 
> > > Using DEFINE_MUTEX() does not gain anything for us, it will generate
> > > unnecessary extra size for the bcache.ko.
> > > ines.
> > 
> > How can the final binary have larger size by just static declaration?
> > By using DEFINE_MUTEX, the mutex is initialized at compile time. It'll
> > save initialization at run time and one line of code will be less also
> > from text section. 
> > 
> > #### with no change (dynamic initialization)
> > size drivers/md/bcache/bcache.ko
> >    text	   data	    bss	    dec	    hex	filename
> >  187792	  25310	    152	 213254	  34106	drivers/md/bcache/bcache.ko
> > 
> > #### with patch applied (static initialization)
> >    text	   data	    bss	    dec	    hex	filename
> >  187751	  25342	    120	 213213	  340dd	drivers/md/bcache/bcache.ko
> > 
> > Module's binary size has decreased by 41 bytes with the path applied
> > (x86_64 arch).
> > 
> Anybody has any thoughts on it?
>

I think you're right and the response is puzzling.  But who cares?  It's
a small thing.  Leave it and move on.

regards,
dan carpenter
