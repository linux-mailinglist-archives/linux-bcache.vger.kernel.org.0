Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E199C39814
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jun 2019 23:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfFGVwt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jun 2019 17:52:49 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34810 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfFGVwt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jun 2019 17:52:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id c26so5038217edt.1
        for <linux-bcache@vger.kernel.org>; Fri, 07 Jun 2019 14:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YX65gJaYrjvp7uhs5BCa+5r3FOnpkKlt1cD1onK+L6Q=;
        b=NVBiYELT8xEYZtMYbm0LwwZqERwZ/EEVzh+S8X9Lam+SL7rmslbC/3NMUvPwX0NT08
         mgVJ+ztOwQTJpjdgJPTlZHQq+RWnXewwBvPi8zhcLfih+Wt2Ayz+qCKu/26PYYUrp8qo
         fVhJ7DDQKKOYyRVeQr2gT7OcKB1JMMNIqCcIUlB8ZJpF57UY8jeMNzZ2izCSA8MicMs2
         GquJH9RFObMxCcQ85ka9I6EtediNDKiHL5fgGEfGk4vYLFxIVLPGNCtWl5muJCchAsh3
         jqEPyU+WhG7MQFx+DrK5PVHA3YYW0JMgLhEwSe1j//jJn7HK7gUkL3ULaN9LrudY+ul8
         RA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YX65gJaYrjvp7uhs5BCa+5r3FOnpkKlt1cD1onK+L6Q=;
        b=b5/UeprsbLm7ZzNv7V/XRDukVombCCTV1PZ5QPU/Ps64Qb20hkL8+Fx+kzNVobLMKZ
         q1vWuWCFat6MINq0yMEK98g5fMCLjzCMtYv60tZcFdKp5Y7+iEBn3/AnAPcWBordVVm2
         7UCS7ewwQfC24twbaWXXGYTyFKwAAYJL95Xto9KupMeSZ8JTvlhkX+kroPHIaaPcc6ix
         nFELogsfvovgnXROfjkHWzKKgFM+geXsxmMMTuouRTLvjISq5vA625eIPUa7bEc4K2q6
         ldhrbZ7mZRzGKoEQ5S/gGfuVu/zJe91qIYyGgvcyw6eOnqyKX8cVrHgfuLQLcGzotzEC
         KdFg==
X-Gm-Message-State: APjAAAUrvVpbHZJ7h/C3FXZlLo5m6/xlEe4GGzwe8XtefwA25FSfel92
        rfmG47TR2nCRShWnidPi9ZhI1w==
X-Google-Smtp-Source: APXvYqx6RdYOJDTtpgvtp5O+1fLuYhb6R04zMCJTpEmjgKedXp+8KXsHXIJm+aUloKY9aBDcDx3byQ==
X-Received: by 2002:a17:906:3daa:: with SMTP id y10mr36954067ejh.65.1559944367463;
        Fri, 07 Jun 2019 14:52:47 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id d16sm802817edx.85.2019.06.07.14.52.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 14:52:46 -0700 (PDT)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
From:   Rolf Fokkens <rolf@rolffokkens.nl>
To:     Nix <nix@esperi.org.uk>, Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        Pierre JUHEN <pierre.juhen@orange.fr>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
 <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
 <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
 <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de> <878suzfk4a.fsf@esperi.org.uk>
 <3340607a-bb62-0bc6-420f-8338283d31d7@rolffokkens.nl>
Message-ID: <5d3209f4-25f1-723c-13e1-a639071964a6@rolffokkens.nl>
Date:   Fri, 7 Jun 2019 23:52:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3340607a-bb62-0bc6-420f-8338283d31d7@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Some potential progress: https://bugzilla.kernel.org/show_bug.cgi?id=203573

On 5/30/19 2:50 PM, Rolf Fokkens wrote:
> Not being sure if people here follow the issue at Fedora I'd like to 
> pass a suggestion: 
> https://bugzilla.redhat.com/show_bug.cgi?id=1708315#c27
>
> On 5/22/19 1:44 AM, Nix wrote:
>> On 21 May 2019, Coly Li uttered the following:
>>> Also I try to analyze the assemble code of bcache, just find out the
>>> generated assembly code between gcc9 and gcc7 is quite different. For
>>> gcc9 there is a XXXX.cold part. So far I can not tell where the problem
>>> is from yet.
>> This is hot/cold partitioning. You can turn it off with
>> -fno-reorder-blocks-and-partition and see if that helps things (and if
>> it doesn't, it should at least make stuff easier to compare).
>
>

