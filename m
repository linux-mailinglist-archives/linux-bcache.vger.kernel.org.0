Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51603F8A8B
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Nov 2019 09:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbfKLIfF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 03:35:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:47678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfKLIfF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 03:35:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4405AC68;
        Tue, 12 Nov 2019 08:35:03 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Michael Lyle <mlyle@lyle.org>
Cc:     Christian Balzer <chibi@gol.com>,
        linux-bcache <linux-bcache@vger.kernel.org>
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
 <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
 <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
 <CAJ+L6qcBpoud8sHhZ64_3Ce9FfzSSUQeXM8MX82cmkREmuFByA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <adfc146a-fd99-6688-a6bf-036be6a8e6a0@suse.de>
Date:   Tue, 12 Nov 2019 16:34:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAJ+L6qcBpoud8sHhZ64_3Ce9FfzSSUQeXM8MX82cmkREmuFByA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/12 1:04 下午, Michael Lyle wrote:
> On Mon, Nov 11, 2019 at 9:00 PM Coly Li <colyli@suse.de> wrote:
>> It seems Areca RAID adapter can not handle high random I/O pressure
>> properly and even worse then regular write I/O rate (am I right ?).
> 

Hi Mike,

> I believe what his data shows is that when the only workload is
> writeback, it's all random write and isn't coalesced.  Areca is pretty
> good with random write, but because we sort on LBA already the adapter
> cache provides no benefit to allow further I/O coalescing.
> 
> OTOH, I liked the system we had before where we had at most 1 idle
> writeback outstanding at a time, because it was guaranteed to not
> create excessive load on the cache or backing device.  I think his
> chief objection is that he uses the cache device for other things and
> doesn't want its idle utilization to be high.

Oh, I see, thanks for your information.

It seems there should be a method to permit people disable maximum
writeback rate if they don't like it.

-- 

Coly Li
