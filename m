Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF9665FD77
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 10:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjAFJTW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 04:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjAFJTH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 04:19:07 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B9C6B5B4
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 01:19:06 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id i10so903681vsr.12
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jan 2023 01:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=BqI9T+0NLSRqO+gLXIqfqqT8pKAaQMS1UtU7qzWGzsaND5xL5vYJLqRw614SdxkIsG
         tRL+qLtg6j6Ipk3b99C/hilGg8u89vAW3jGPpZ3o4a0LsyTZzGZaQoH9tgIBMa1LZAFW
         XHG8LtD67QdrdVlUPDNBeZoFqOCpZEWtA6p457zEzsizpTNGqwDju2kMTuM6+wSvi/5f
         OjvvEjTp9JrNc5tOCkD2qFmM8DTNOWzCLba+EreTXgaj5XQb5t8vBjVdbK2rpkTz2sjQ
         M7N8IYpIOmCh8M4PPtFfcYlCb1I1Wk2tXHeqbcXRIFI4sxGrb6yomJDGyndy2qKPO7F3
         fWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=4s9tGY1HxKILNDBPTWlcN0ol3cTcRTmINd/UdYKGPPMb6E++A+Vx5AnSkt4jURMOYe
         P5qpZdTdJqL+PoO+C8hIuDvixMTe+AJkJIMrmhqhkRgzZDhNn4QzHTJa3zC9NKnmdQGV
         ov7u8VFFH54PdktofRirqToi7NmkW3iy1po/4QUjzNNDTUdskBVPZvkahJ/bE7UdcUzI
         fVkBBuvl7S6Qnj+Q4C/ylhre9Q9QM916w6h3FoO1VKpRqyIP8TKEjbqD/bSz8WloL5IZ
         m0qKLzrKRq919115FOuzbrdMt7VJq9aXXsj1QlK3l/lZDanKmxUtBPwSSXPlmKzMLEv3
         S0fg==
X-Gm-Message-State: AFqh2kpCx1uN7DcuMce8PTfhT5fVzQmrTDZ+YJUTcIo49sTfiW2uBgHo
        HCciNIb8k+mR19iidzEvXqO55HysEsFlVYj+gpo=
X-Google-Smtp-Source: AMrXdXurvLRcLiMOWitTt9rEpFU/HNVS4rk0YP2Eq3mK1r/eIXTtIQxbZFMg/hjbbDfHG0AtapjizSbDjONRItaBWcY=
X-Received: by 2002:a05:6102:508a:b0:3ce:a5a8:1f22 with SMTP id
 bl10-20020a056102508a00b003cea5a81f22mr1564870vsb.28.1672996745100; Fri, 06
 Jan 2023 01:19:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:ddd7:0:b0:325:e5:9888 with HTTP; Fri, 6 Jan 2023
 01:19:04 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <daswas250@gmail.com>
Date:   Fri, 6 Jan 2023 01:19:04 -0800
Message-ID: <CAM1W4N7ESa2cLb+6e2qAUvxybJ2JDMNRHOiUfNf70wJgZw-hSg@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5105]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [daswas250[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [daswas250[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

-- 
Hello Dear,
How are you doing.My name is DR. AVA SMITH from United States.
I am a French and American national (dual) living in the U.S and
sometimes in the U.K for the Purpose of Work.
I hope you consider my friend request and consider me worthy to be your friend.
I will share some of my pics and more details about my self when i get
your response
With love
Dr. Ava
