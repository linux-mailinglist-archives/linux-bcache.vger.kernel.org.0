Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B5784E59
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Aug 2023 03:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjHWBne (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Aug 2023 21:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjHWBn2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Aug 2023 21:43:28 -0400
X-Greylist: delayed 919 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:43:26 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B1510D
        for <linux-bcache@vger.kernel.org>; Tue, 22 Aug 2023 18:43:26 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-4f-64e54bbca6c3
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 2B.FB.10987.CBB45E46; Wed, 23 Aug 2023 04:58:52 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=hz55lQmDwARG+MMadiCGMAN5xFNmK6pAuE51cVFp9t4eLwf7OgfOgm+I9fP0oZk02
          9FYKVSgZ0CsZMqww2UpvK4eW04sQ94/4JcZrUQ4r92BFeCbuBLCXO74xiHhM4G3oh
          vlqPS+tVxo1o7qGeg7PzcEhrvF2qUbngZ721tVgFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=DDk6PfLJwbV+lZttbK0vV00a7+6f6M39/A48Sjp4HaocZ/3couUnZDAHpkrqQrB5H
          vmHoMgmiJIEIsxwtU0K0Ot0K4z76IFv7R8boFErjT6pZ4ehT968epVdpVLCI1l52G
          fEL7IQd04cPN5V1f8C4GI5fXf7Hx/HBloQ5+5FNPw=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:30:58 +0500
Message-ID: <2B.FB.10987.CBB45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-bcache@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:12 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGW3eP99MUg4VnjCyObbvG5MDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGknUXWAp2M1e09S9iaWB8zNTFyMkhIWAisefIEsYuRi4OIYE9
        TBLXTxxnBnFYBFYzS+xc+58dwnnILLH36h02iLJmRonffb/YQPp5BawlJn5azAhiMwvoSdyY
        OgUqLihxcuYTFoi4tsSyha+BxnIA2WoSX7tKQMLCAmISn6YtYwcJiwgoSDxaWA8SZhPQl1jx
        tRlsIouAqsSBG/NYQWwhASmJjVfWs01g5J+FZNksJMtmIVk2C2HZAkaWVYwSxZW5icBQSzbR
        S87PLU4sKdbLSy3RK8jexAgMw9M1mnI7GJdeSjzEKMDBqMTD+3PdkxQh1sQyoK5DjBIczEoi
        vNLfH6YI8aYkVlalFuXHF5XmpBYfYpTmYFES57UVepYsJJCeWJKanZpakFoEk2Xi4JRqYIyS
        y3+/Pztm5+HzzrdvbU1bYhf+LPxfqoNr59FSg9wEhwMX5eP3fzFQ28/52WNjJOOHmgjNB9GH
        Hn64+S6A8d3UT3eq7zrYPTyw3bai7RCnXlV0ivi1K9e/7P7xMPDS3u8iFyxbuZwauc7snMBZ
        +qHinElCwLfAg82Kirxeiy7mcsaxOfDxVCqxFGckGmoxFxUnAgC0r5J7PwIAAA==
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_LOW,RCVD_IN_SBL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: iesco.com.pk]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [94.156.6.90 listed in zen.spamhaus.org]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [203.124.41.30 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

