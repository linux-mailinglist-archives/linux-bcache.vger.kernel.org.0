Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48A61C3EFB
	for <lists+linux-bcache@lfdr.de>; Mon,  4 May 2020 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgEDPwF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 May 2020 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDPwF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 11:52:05 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E4C061A0E
        for <linux-bcache@vger.kernel.org>; Mon,  4 May 2020 08:52:04 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w4so12803091ioc.6
        for <linux-bcache@vger.kernel.org>; Mon, 04 May 2020 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1zJVO2gIxX4aAMF9gU336L6lcgeaMOzZQkhUWsTLGpo=;
        b=og5xvkjhQE+U8D+oeADyVJ0arMRIquQWzh5QoboLqz8lHbm2eheAnQow6wqDABGhp9
         xIO6yyBYbZ4iPaWhGIYNKrq585MRlGPxqF5YanRAqXpuFLO1z08nblnrza0pYT1WD8Er
         aMsjqIF6AYtDIkCmcBB7PGliKNB8MmfrnjlFNTWf3UULNtMa2LNByunIDFJmj3w4nKpW
         4Bw71whEBFmfqr4tsqYK3LH4O8fqCXeWCwEUA8PandEUAuY7BGnWNzyvmywuyv56wkSy
         IyD005x3jT3e/tONd/gFIm0nryDxvwtQZsCtHchPGcsIe+AGAI8E1zekI9wM2fcAv3vg
         iJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1zJVO2gIxX4aAMF9gU336L6lcgeaMOzZQkhUWsTLGpo=;
        b=RUtrDUq+MYlRcU2XtaQHTI0HgQV45ZupJobk9+aDVb2+66ZRtA7llxohq9hiRbTdoa
         uiddsH0CvX7tO0iLHyHyWj5WXpwONUOeA4jwat5W3ZfluQNj8bqhU+jeHNGzxT+xGhdE
         EhwkO49Y5DgUAFQfteo7QN8qitZM3dz33gMzJBn3cLF1fpv2goUIHEf1XQfj/dNsKIl3
         YbNHyyXvS7k1n5vcghBxbpOwlGoCoNoSzJbcBDiv6tXZFf9GD7Jwk9DbVFgw1l+pge3n
         t/IBeo8RlrqbJqjl6HcEn4d7c5vQPrdizdcmprAOec+CCcwUKl8hqctmo+s29ADwEnRo
         3ENQ==
X-Gm-Message-State: AGi0PuZcuUfVcQCnV4reSKW774fR5UidZ2tUqgGG3F/kYnck7JeXA5ME
        KurF76g946IXDafbiXKg9m5URQ==
X-Google-Smtp-Source: APiQypKjMgjkihbrm+NDJF6d0zYsKgvVAb1cfCwDx2zBStLgPRBkp5ul4VTYBPvR1LnzG5UhMLclZw==
X-Received: by 2002:a02:3b1d:: with SMTP id c29mr15431997jaa.67.1588607523292;
        Mon, 04 May 2020 08:52:03 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x75sm5278407ill.33.2020.05.04.08.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:52:02 -0700 (PDT)
Subject: Re: [PATCH 0/2] bcache patches for Linux v5.7-rc5
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200504153529.2242-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ade380f2-e124-9e64-572a-3299bebcd658@kernel.dk>
Date:   Mon, 4 May 2020 09:52:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504153529.2242-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/4/20 9:35 AM, Coly Li wrote:
> Hi Jens,
> 
> These two patches are in my testing directory for weeks and it is
> about time to submit them for Linux v5.7-rc5.
> 
> The first one from Colin helps to remove unncessary local variables.
> And Joe contributes second patch to improve the kernel message format
> by remove extra '\n' from existing pr_format() and adds the '\n' to
> the location of printing kernel messages. 
> 
> Please them for v5.7.

Why not 5.8? Doesn't look critical, nor something that was introduced
in this series. More like cleanups, hence should go into 5.8 instead.

-- 
Jens Axboe

