Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDC9BC42D
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2019 10:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439044AbfIXIj5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Sep 2019 04:39:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:53082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439012AbfIXIj5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Sep 2019 04:39:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B257B670;
        Tue, 24 Sep 2019 08:39:55 +0000 (UTC)
Subject: Re: Issue with kernel 5.x
To:     Marcelo RE <marcelo.re@gmail.com>
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de>
Date:   Tue, 24 Sep 2019 16:39:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/9/24 1:33 上午, Marcelo RE wrote:
> Hi.
> 
>  have problems running bcache with the kernel 5.x in KUbuntu. It work
> fine with kernel 4.x but fail to start with 5.x. Currently using 5.2.3
> (linux-image-unsigned-5.2.3-050203-generic).
> When power on the laptop, sometimes it start to busybox and sometime
> it boot fine.
> If boot to busybox, I just enter reboot until it starts correctly.
> I tested:
> linux-image-4.15.0-29-generic
> linux-image-4.15.0-34-generic
> linux-image-5.0.0-20-generic
> linux-image-5.0.0-21-generic
> linux-image-5.0.0-23-generic
> linux-image-5.0.0-25-generic
> linux-image-5.0.0-27-generic
> linux-image-5.0.0-29-generic
> linux-image-unsigned-5.2.3-050203-generic
> 
> What can be done?

It is not easy to locate the problem by kernel versions. There are quite
a lot fixes since 4.15 to 5.2.

If there is any more information or clue, maybe I can help to guess.

-- 

Coly Li
